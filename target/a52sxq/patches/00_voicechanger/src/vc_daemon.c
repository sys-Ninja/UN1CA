/*
 * vc_daemon — the whole voice changer in one root process.
 *
 * Replaces the app's Kotlin loop plus the three helper binaries (vc_capture,
 * vc_inject, vc_mute_loop). Nothing here shells out, so it can run as an init
 * service inside the ROM instead of behind `su` + ProcessBuilder.
 *
 * Pipeline, all verified live on SM-A528B (lahaina-yupikidp, VoLTE):
 *
 *   SWR_MIC0 ─┬─ DEC0/DEC1 ── TX_CDC_DMA_TX_3 ── modem     (gain forced to 0)
 *             └─ DEC2 ─────── TX_CDC_DMA_TX_4 ── MultiMedia5 (pcm dev 9, 48 kHz)
 *                                                    │
 *                             decimate 6:1 → AGC → Sonic pitch shift
 *                                                    │
 *              Incall_Music ── MultiMedia1 ── pcm dev 0, 8 kHz ── uplink
 *
 * Zeroing TX_DEC0/1 Volume is the only way to silence the mic that keeps the
 * Incall_Music injection alive: every routing-level cut tears down the same TX
 * DMA the injection flows through. That gain stage sits before every capture
 * path though, which is why the private DEC2 channel exists.
 *
 * Runtime control is entirely via properties:
 *   persist.unica.vc.enabled    bool   master switch
 *   persist.unica.vc.mode       auto|manual
 *   sys.unica.vc.active         bool   per-call trigger, only read in manual mode
 *   persist.sys.unica.vc.preset  string preset name (or legacy index) from kPresets
 *   persist.sys.unica.vc.semitones  float  used when preset == kCustomPreset
 *   persist.unica.vc.agc        bool   default true
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <dlfcn.h>
#include <math.h>
#include <errno.h>
#include <stdarg.h>
#include <time.h>
#include <sched.h>
#include <sys/system_properties.h>
#include <android/log.h>

#include "sonic.h"

/* Init redirects a service's stdout/stderr to /dev/null, so everything has to
 * go through logcat. stderr is kept as well for `adb shell vc_daemon` runs. */
#define LOG_TAG "vc_daemon"

__attribute__((format(printf, 2, 3)))
static void vc_log(int prio, const char *fmt, ...)
{
    char buf[512];
    va_list ap;

    va_start(ap, fmt);
    vsnprintf(buf, sizeof(buf), fmt, ap);
    va_end(ap);

    __android_log_write(prio, LOG_TAG, buf);
    fprintf(stderr, "%s\n", buf);
    fflush(stderr);
}

#define LOGI(...) vc_log(ANDROID_LOG_INFO, __VA_ARGS__)
#define LOGW(...) vc_log(ANDROID_LOG_WARN, __VA_ARGS__)
#define LOGE(...) vc_log(ANDROID_LOG_ERROR, __VA_ARGS__)

/* ── tinyalsa ABI (dlopen'd; the NDK ships no headers for it) ─────────────── */

#define PCM_OUT           0x00000000
#define PCM_IN            0x10000000
#define PCM_FORMAT_S16_LE 0

struct pcm_config {
    unsigned int channels;
    unsigned int rate;
    unsigned int period_size;
    unsigned int period_count;
    int format;
    unsigned int start_threshold;
    unsigned int stop_threshold;
    unsigned int silence_threshold;
    unsigned int silence_size;
    int avail_min;
};

struct pcm;
struct mixer;
struct mixer_ctl;

typedef struct pcm *       (*fn_pcm_open)(unsigned int, unsigned int, unsigned int, struct pcm_config *);
typedef int                (*fn_pcm_close)(struct pcm *);
typedef int                (*fn_pcm_is_ready)(struct pcm *);
typedef int                (*fn_pcm_read)(struct pcm *, void *, unsigned int);
typedef int                (*fn_pcm_write)(struct pcm *, const void *, unsigned int);
typedef unsigned int       (*fn_pcm_frames_to_bytes)(struct pcm *, unsigned int);
typedef const char *       (*fn_pcm_get_error)(struct pcm *);
typedef struct mixer *     (*fn_mixer_open)(unsigned int);
typedef void               (*fn_mixer_close)(struct mixer *);
typedef unsigned int       (*fn_mixer_get_num_ctls)(struct mixer *);
typedef struct mixer_ctl * (*fn_mixer_get_ctl)(struct mixer *, unsigned int);
typedef struct mixer_ctl * (*fn_mixer_get_ctl_by_name)(struct mixer *, const char *);
typedef const char *       (*fn_mixer_ctl_get_name)(struct mixer_ctl *);
typedef unsigned int       (*fn_mixer_ctl_get_num_values)(struct mixer_ctl *);
typedef int                (*fn_mixer_ctl_get_value)(struct mixer_ctl *, unsigned int);
typedef int                (*fn_mixer_ctl_set_value)(struct mixer_ctl *, unsigned int, int);
typedef int                (*fn_mixer_ctl_set_enum_by_string)(struct mixer_ctl *, const char *);

static struct {
    fn_pcm_open                     pcm_open;
    fn_pcm_close                    pcm_close;
    fn_pcm_is_ready                 pcm_is_ready;
    fn_pcm_read                     pcm_read;
    fn_pcm_write                    pcm_write;
    fn_pcm_frames_to_bytes          pcm_frames_to_bytes;
    fn_pcm_get_error                pcm_get_error;
    fn_mixer_open                   mixer_open;
    fn_mixer_close                  mixer_close;
    fn_mixer_get_num_ctls           mixer_get_num_ctls;
    fn_mixer_get_ctl                mixer_get_ctl;
    fn_mixer_get_ctl_by_name        mixer_get_ctl_by_name;
    fn_mixer_ctl_get_name           mixer_ctl_get_name;
    fn_mixer_ctl_get_num_values     mixer_ctl_get_num_values;
    fn_mixer_ctl_get_value          mixer_ctl_get_value;
    fn_mixer_ctl_set_value          mixer_ctl_set_value;
    fn_mixer_ctl_set_enum_by_string mixer_ctl_set_enum_by_string;
} alsa;

/* ── Audio path constants (a52sxq / lahaina-yupikidp) ─────────────────────── */

#define CARD            0
#define DEV_INJECT      0      /* MultiMedia1 → Incall_Music */
#define DEV_CAPTURE     9      /* MultiMedia5 ← TX_CDC_DMA_TX_4 */

#define CAP_RATE        48000
#define OUT_RATE        8000   /* the incall_music path is hard-wired to 8 kHz */
#define DECIM           (CAP_RATE / OUT_RATE)
#define CAP_FRAMES      256                  /* 32 ms of output per read */
#define CAP_IN_FRAMES   (CAP_FRAMES * DECIM)
#define INJ_FRAMES      1024                 /* 128 ms period, matches vc_inject */

#define CHUNKS_PER_SEC  (OUT_RATE / CAP_FRAMES)   /* 31 */
#define HK_CHUNKS       8                         /* ~256 ms */

#define TX_DEC_MUTED    0
#define TX_DEC_DEFAULT  96
/* Measured peak on normal speech: 96 → ~1900, 104 → ~3700, 108/110 → clipped at
 * full scale. 108 was shipped and clipped on every loud syllable. */
#define TX_DEC2_GAIN    104
#define TX_DEC2_DEFAULT 84

/* Anti-alias filter before the 6:1 decimation. A plain boxcar average of 6 is
 * only -11 dB at 6 kHz and -16 dB at 20 kHz, so most of the 4..24 kHz band
 * folded straight back on top of the speech and came out as harsh noise. */
#define AA_CUTOFF       3200.0f
#define AA_SECTIONS     3

/* Envelope-follower AGC. The shipped values pinned the gain at the ×10 maximum
 * for 70% of a call (measured live) because the noise floor was set to 150
 * while the real room floor is 350..800 — the gate never engaged and the
 * background got amplified along with the voice. */
#define AGC_TARGET      18000.0f
#define AGC_MAX_GAIN    6.0f
#define AGC_ENV_RELEASE 0.94f   /* ~500 ms over 32 ms chunks */
#define AGC_NOISE_FLOOR 700.0f  /* below this the gain is frozen, not reset */
#define AGC_ATTACK      0.60f   /* come down fast, so peaks do not clip */
#define AGC_RECOVER     0.06f   /* go up slowly, so noise is not pumped */

/* ── Voice presets ────────────────────────────────────────────────────────── */

/* Pitch only, deliberately no tempo. Sonic's rate divides the output length by
 * the same factor, but this sink is a fixed 8 kHz stream feeding the modem, so
 * rate=0.95 produced 5.3% more samples than real time (measured: +5.16% over a
 * 70 s call) until the injection ring overflowed — a hiccup every 6.7 s. */
struct preset {
    const char *name;
    float pitch;   /* frequency multiplier; 2^(semitones/12) */
};

static const struct preset kPresets[] = {
    { "normal",     1.00f },
    { "female",     1.26f },  /* +4 st */
    { "male",       0.79f },  /* -4 st */
    { "child",      1.68f },  /* +9 st */
    { "old_man",    0.87f },  /* -2.5 st */
    { "old_woman",  1.12f },  /* +2 st */
    { "chipmunk",   2.00f },  /* +12 st */
    { "giant",      0.63f },  /* -8 st */
    { "helium",     1.50f },  /* +7 st */
    { "custom",     1.00f },  /* driven by persist.sys.unica.vc.semitones */
};
#define NUM_PRESETS   ((int)(sizeof(kPresets) / sizeof(kPresets[0])))
#define CUSTOM_PRESET (NUM_PRESETS - 1)

/* ── Properties ───────────────────────────────────────────────────────────── */

#define PROP_ENABLED   "persist.sys.unica.vc.enabled"
#define PROP_MODE      "persist.sys.unica.vc.mode"
#define PROP_ACTIVE    "persist.sys.unica.vc.active"
#define PROP_PRESET    "persist.sys.unica.vc.preset"
#define PROP_SEMITONES "persist.sys.unica.vc.semitones"
#define PROP_AGC       "persist.sys.unica.vc.agc"

static void prop_get(const char *key, char *out, size_t out_len, const char *def)
{
    char buf[PROP_VALUE_MAX];
    int n = __system_property_get(key, buf);
    snprintf(out, out_len, "%s", (n > 0) ? buf : def);
}

static int prop_bool(const char *key, int def)
{
    char v[PROP_VALUE_MAX];
    prop_get(key, v, sizeof(v), def ? "true" : "false");
    return !strcmp(v, "true") || !strcmp(v, "1") || !strcmp(v, "on");
}

static float prop_float(const char *key, float def)
{
    char v[PROP_VALUE_MAX];
    char d[32];
    snprintf(d, sizeof(d), "%f", def);
    prop_get(key, v, sizeof(v), d);
    return strtof(v, NULL);
}

/* ── Mixer helpers ────────────────────────────────────────────────────────── */

static struct mixer *g_mixer;

static struct mixer_ctl *ctl(const char *name)
{
    struct mixer_ctl *c = alsa.mixer_get_ctl_by_name(g_mixer, name);
    if (!c)
        LOGW("mixer control not found: %s", name);
    return c;
}

/* Several of these controls carry more than one value (the stock tinymix
 * invocations passed "1 1"), so write every value rather than just index 0. */
static int ctl_set_int(const char *name, int value)
{
    struct mixer_ctl *c = ctl(name);
    if (!c)
        return -1;
    unsigned int n = alsa.mixer_ctl_get_num_values(c);
    if (n == 0)
        n = 1;
    for (unsigned int i = 0; i < n; i++) {
        if (alsa.mixer_ctl_set_value(c, i, value) != 0) {
            LOGW("failed to set %s[%u] = %d", name, i, value);
            return -1;
        }
    }
    return 0;
}

static int ctl_set_enum(const char *name, const char *value)
{
    struct mixer_ctl *c = ctl(name);
    if (!c)
        return -1;
    if (alsa.mixer_ctl_set_enum_by_string(c, value) != 0) {
        LOGW("failed to set %s = %s", name, value);
        return -1;
    }
    return 0;
}

static int ctl_get_int(const char *name, int def)
{
    struct mixer_ctl *c = alsa.mixer_get_ctl_by_name(g_mixer, name);
    return c ? alsa.mixer_ctl_get_value(c, 0) : def;
}

/* A VoLTE call is up once the modem's voice TX mixer is routed. Probing this is
 * free and has no side effects, unlike opening the capture PCM (which only
 * succeeds mid-call because the AFE topology id is 0 otherwise).
 *
 * Only the VoiceMMode mixers are trustworthy. "TX_AIF1_CAP Mixer DEC0" is also
 * On for any ordinary recording, and the HAL leaves it On for a while after a
 * hang-up — using it as a probe made the daemon reopen a dead session once a
 * second after every call. */
static int call_is_active(void)
{
    static const char *probes[] = {
        "VoiceMMode1_Tx Mixer TX_CDC_DMA_TX_3_MMode1",
        "VoiceMMode2_Tx Mixer TX_CDC_DMA_TX_3_MMode2",
    };
    for (size_t i = 0; i < sizeof(probes) / sizeof(probes[0]); i++) {
        struct mixer_ctl *c = alsa.mixer_get_ctl_by_name(g_mixer, probes[i]);
        if (c && alsa.mixer_ctl_get_value(c, 0) > 0)
            return 1;
    }
    return 0;
}

/* ── Run gating ───────────────────────────────────────────────────────────── */

static volatile sig_atomic_t g_running = 1;

static void on_sig(int s) { (void)s; g_running = 0; }

static int should_run(void)
{
    char mode[PROP_VALUE_MAX];

    if (!prop_bool(PROP_ENABLED, 0))
        return 0;

    prop_get(PROP_MODE, mode, sizeof(mode), "auto");
    if (!strcmp(mode, "manual"))
        return prop_bool(PROP_ACTIVE, 0);

    return 1;
}

/* ── Anti-alias filter ────────────────────────────────────────────────────── */

struct biquad { float b0, b1, b2, a1, a2, z1, z2; };

static void biquad_lowpass(struct biquad *f, float fs, float fc, float q)
{
    float w     = 2.0f * (float)M_PI * fc / fs;
    float cw    = cosf(w);
    float alpha = sinf(w) / (2.0f * q);
    float a0    = 1.0f + alpha;

    f->b0 = ((1.0f - cw) * 0.5f) / a0;
    f->b1 = (1.0f - cw) / a0;
    f->b2 = f->b0;
    f->a1 = (-2.0f * cw) / a0;
    f->a2 = (1.0f - alpha) / a0;
    f->z1 = f->z2 = 0.0f;
}

/* Transposed direct form II — two state words, no history buffer. */
static inline float biquad_run(struct biquad *f, float x)
{
    float y = f->b0 * x + f->z1;
    f->z1 = f->b1 * x - f->a1 * y + f->z2;
    f->z2 = f->b2 * x - f->a2 * y;
    return y;
}

/* ── Session ──────────────────────────────────────────────────────────────── */

/* The Settings UI stores the preset by name; older builds stored the index.
   Accept both. */
static int preset_index(void)
{
    char v[PROP_VALUE_MAX];
    prop_get(PROP_PRESET, v, sizeof(v), kPresets[0].name);

    for (int i = 0; i < NUM_PRESETS; i++)
        if (!strcmp(v, kPresets[i].name))
            return i;

    char *end;
    long n = strtol(v, &end, 10);
    if (end != v && *end == '\0' && n >= 0 && n < NUM_PRESETS)
        return (int)n;

    LOGW("unknown preset \"%s\", falling back to %s", v, kPresets[0].name);
    return 0;
}

static void apply_preset(sonicStream stream, int *cur_preset, float *cur_semi)
{
    int preset = preset_index();

    float semi = prop_float(PROP_SEMITONES, 0.0f);
    if (semi < -24.0f) semi = -24.0f;
    if (semi >  24.0f) semi =  24.0f;

    if (preset == *cur_preset && (preset != CUSTOM_PRESET || semi == *cur_semi))
        return;

    float pitch = kPresets[preset].pitch;
    if (preset == CUSTOM_PRESET)
        pitch = powf(2.0f, semi / 12.0f);

    sonicSetPitch(stream, pitch);
    *cur_preset = preset;
    *cur_semi   = semi;

    LOGI("PRESET %s pitch=%.3f", kPresets[preset].name, pitch);
}

static void route_teardown(void)
{
    /* Order matters: give the mic back to the modem before dismantling the
     * private channel, so a hang-up mid-teardown never leaves the call muted. */
    ctl_set_int("TX_DEC0 Volume", TX_DEC_DEFAULT);
    ctl_set_int("TX_DEC1 Volume", TX_DEC_DEFAULT);
    ctl_set_int("MultiMedia5 Mixer TX_CDC_DMA_TX_4", 0);
    ctl_set_int("TX_AIF2_CAP Mixer DEC2", 0);
    ctl_set_enum("TX SMIC MUX2", "ZERO");
    ctl_set_int("TX_DEC2 Volume", TX_DEC2_DEFAULT);
    ctl_set_int("Incall_Music Audio Mixer MultiMedia1", 0);
}

/* Re-assert every control the private channel depends on.
 *
 * The HAL reloads the whole voicemmode1-call mixer path from its XML whenever
 * the call route is torn down and rebuilt, which happens mid-call on its own:
 * telephony reports g_call_state 514 → 257, the HAL does adev_set_mode 2 → 0
 * and disable_audio_route/enable_audio_route on voicemmode1-call, all while the
 * call is still up. Observed twice in a two-minute call. Only TX_DEC0/1 used to
 * be re-checked, so after a rebuild the other five controls stayed at their
 * stock values and the capture stream went dead or silent. */
static int route_verify(void)
{
    int fixed = 0;

    if (ctl_get_int("Incall_Music Audio Mixer MultiMedia1", 1) != 1) {
        ctl_set_int("Incall_Music Audio Mixer MultiMedia1", 1);
        ctl_set_int("Playback 0 Volume", 8192);
        fixed++;
    }
    if (ctl_get_int("TX_AIF2_CAP Mixer DEC2", 1) != 1) {
        ctl_set_enum("TX SMIC MUX2", "SWR_MIC0");
        ctl_set_int("TX_AIF2_CAP Mixer DEC2", 1);
        fixed++;
    }
    if (ctl_get_int("MultiMedia5 Mixer TX_CDC_DMA_TX_4", 1) != 1) {
        ctl_set_enum("TX_CDC_DMA_TX_4 Channels", "One");
        ctl_set_int("MultiMedia5 Mixer TX_CDC_DMA_TX_4", 1);
        fixed++;
    }
    if (ctl_get_int("TX_DEC2 Volume", TX_DEC2_GAIN) != TX_DEC2_GAIN) {
        ctl_set_int("TX_DEC2 Volume", TX_DEC2_GAIN);
        fixed++;
    }
    /* Muting comes last: never silence the mic while the private channel that
     * replaces it is still broken. */
    if (ctl_get_int("TX_DEC0 Volume", 0) != TX_DEC_MUTED ||
        ctl_get_int("TX_DEC1 Volume", 0) != TX_DEC_MUTED) {
        ctl_set_int("TX_DEC0 Volume", TX_DEC_MUTED);
        ctl_set_int("TX_DEC1 Volume", TX_DEC_MUTED);
        fixed++;
    }
    return fixed;
}

/* Runs one call's worth of audio. Returns when the call ends, the feature is
 * switched off, or something in the path fails. */
static void run_session(void)
{
    struct pcm_config cap_cfg, inj_cfg;
    struct pcm *cap = NULL, *inj = NULL;
    short *cap_buf = NULL, *pcm_in = NULL, *sonic_out = NULL, *inj_buf = NULL;
    sonicStream stream = NULL;
    unsigned int cap_bytes, inj_bytes;
    int inj_fill = 0;
    int cur_preset = -1;
    float cur_semi = 1e9f;
    float agc_env = 0.0f, agc_gain = 1.0f;
    int use_agc = prop_bool(PROP_AGC, 1);
    long chunks = 0;
    int peak_in = 0, resets = 0, clipped = 0, dropped = 0;
    struct biquad aa[AA_SECTIONS];

    /* 6th-order Butterworth = three cascaded biquads with these Q values.
     * Measured: -1.6 dB at 3 kHz, -35 dB at 6 kHz, -56 dB at 9 kHz. */
    static const float kAaQ[AA_SECTIONS] = { 0.51764f, 0.70711f, 1.93185f };
    for (int i = 0; i < AA_SECTIONS; i++)
        biquad_lowpass(&aa[i], (float)CAP_RATE, AA_CUTOFF, kAaQ[i]);

    LOGI("SESSION start");

    /* Injection first: if it cannot open we must not mute the mic, or the
     * other party would hear nothing at all. */
    ctl_set_int("Incall_Music Audio Mixer MultiMedia1", 1);
    ctl_set_int("Playback 0 Volume", 8192);   /* unity, range 0..8192 */

    memset(&inj_cfg, 0, sizeof(inj_cfg));
    inj_cfg.channels     = 1;
    inj_cfg.rate         = OUT_RATE;
    inj_cfg.period_size  = INJ_FRAMES;
    inj_cfg.period_count = 2;
    inj_cfg.format       = PCM_FORMAT_S16_LE;

    inj = alsa.pcm_open(CARD, DEV_INJECT, PCM_OUT, &inj_cfg);
    if (!inj || !alsa.pcm_is_ready(inj)) {
        LOGE("inject pcm_open: %s", inj ? alsa.pcm_get_error(inj) : "null");
        goto out;
    }

    /* Private capture channel: duplicate SWR_MIC0 into the unused DEC2. */
    ctl_set_enum("TX SMIC MUX2", "SWR_MIC0");
    ctl_set_int("TX_AIF2_CAP Mixer DEC2", 1);
    ctl_set_enum("TX_CDC_DMA_TX_4 Channels", "One");  /* "Two" → AFE -EINVAL */
    ctl_set_int("MultiMedia5 Mixer TX_CDC_DMA_TX_4", 1);
    ctl_set_int("TX_DEC2 Volume", TX_DEC2_GAIN);

    memset(&cap_cfg, 0, sizeof(cap_cfg));
    cap_cfg.channels     = 1;
    cap_cfg.rate         = CAP_RATE;
    cap_cfg.period_size  = CAP_IN_FRAMES;
    cap_cfg.period_count = 4;
    cap_cfg.format       = PCM_FORMAT_S16_LE;

    cap = alsa.pcm_open(CARD, DEV_CAPTURE, PCM_IN, &cap_cfg);
    if (!cap || !alsa.pcm_is_ready(cap)) {
        LOGE("capture pcm_open: %s", cap ? alsa.pcm_get_error(cap) : "null");
        goto out;
    }

    cap_bytes = alsa.pcm_frames_to_bytes(cap, CAP_IN_FRAMES);
    inj_bytes = alsa.pcm_frames_to_bytes(inj, INJ_FRAMES);

    cap_buf   = malloc(cap_bytes);
    pcm_in    = malloc(CAP_FRAMES * sizeof(short));
    sonic_out = malloc(CAP_FRAMES * 4 * sizeof(short));
    inj_buf   = malloc(inj_bytes);
    if (!cap_buf || !pcm_in || !sonic_out || !inj_buf) {
        LOGE("out of memory");
        goto out;
    }

    stream = sonicCreateStream(OUT_RATE, 1);
    if (!stream) {
        LOGE("sonicCreateStream");
        goto out;
    }
    sonicSetSpeed(stream, 1.0f);
    sonicSetRate(stream, 1.0f);
    sonicSetVolume(stream, 1.0f);
    apply_preset(stream, &cur_preset, &cur_semi);

    /* Only now is it safe to silence the mic. */
    ctl_set_int("TX_DEC0 Volume", TX_DEC_MUTED);
    ctl_set_int("TX_DEC1 Volume", TX_DEC_MUTED);

    LOGI("OK capture=%u inject=%u agc=%d", cap_bytes, inj_bytes, use_agc);

    while (g_running) {
        int chunk_peak = 0;

        if (alsa.pcm_read(cap, cap_buf, cap_bytes) != 0) {
            LOGE("pcm_read: %s", alsa.pcm_get_error(cap));
            break;
        }

        /* 48 kHz → 8 kHz: run every input sample through the anti-alias
         * cascade, then keep the last of each group of 6. */
        for (int i = 0; i < CAP_FRAMES; i++) {
            float y = 0.0f;
            for (int k = 0; k < DECIM; k++) {
                y = (float)cap_buf[i * DECIM + k];
                for (int sec = 0; sec < AA_SECTIONS; sec++)
                    y = biquad_run(&aa[sec], y);
            }
            int s = (int)y;
            if (s >  32767) s =  32767;
            if (s < -32768) s = -32768;
            pcm_in[i] = (short)s;
            int a = s < 0 ? -s : s;
            if (a > chunk_peak)
                chunk_peak = a;
        }
        if (chunk_peak > peak_in)
            peak_in = chunk_peak;
        if (chunk_peak >= 32000)
            clipped++;

        /* DEC2 lands well below full scale, so the level has to be made up
         * here — more TX_DEC2 gain clips in the codec, before we can see it. */
        if (use_agc) {
            agc_env = fmaxf((float)chunk_peak, agc_env * AGC_ENV_RELEASE);

            /* Below the room noise floor the gain is held, not driven back to
             * unity: resetting it made the first syllable after every pause
             * come out quiet and then swell. */
            if (agc_env > AGC_NOISE_FLOOR) {
                float wanted = AGC_TARGET / agc_env;
                if (wanted < 1.0f)         wanted = 1.0f;
                if (wanted > AGC_MAX_GAIN) wanted = AGC_MAX_GAIN;
                float step = (wanted < agc_gain) ? AGC_ATTACK : AGC_RECOVER;
                agc_gain += (wanted - agc_gain) * step;
            }

            for (int i = 0; i < CAP_FRAMES; i++) {
                int v = (int)(pcm_in[i] * agc_gain);
                if (v >  32000) v =  32000;
                if (v < -32000) v = -32000;
                pcm_in[i] = (short)v;
            }
        }

        sonicWriteShortToStream(stream, pcm_in, CAP_FRAMES);

        /* Sonic's WSOLA emits in bursts, so a little backlog is normal. More
         * than three injection periods of it is latency that will never be
         * paid back — drop it rather than let the delay grow all call. */
        while (sonicSamplesAvailable(stream) > INJ_FRAMES * 3) {
            sonicReadShortFromStream(stream, sonic_out, CAP_FRAMES * 4);
            dropped++;
        }

        int avail = sonicSamplesAvailable(stream);
        if (avail > CAP_FRAMES * 4)
            avail = CAP_FRAMES * 4;
        int got = (avail > 0) ? sonicReadShortFromStream(stream, sonic_out, avail) : 0;

        for (int i = 0; i < got; i++) {
            inj_buf[inj_fill++] = sonic_out[i];
            if (inj_fill == INJ_FRAMES) {
                if (alsa.pcm_write(inj, inj_buf, inj_bytes) != 0) {
                    LOGE("pcm_write: %s", alsa.pcm_get_error(inj));
                    goto out;
                }
                inj_fill = 0;
            }
        }

        chunks++;

        /* Four times a second, because a mid-call route rebuild takes about
         * half a second end to end — checking once a second let a whole rebuild
         * pass unnoticed. Reading a mixer value is a cheap ioctl. */
        if (chunks % HK_CHUNKS == 0)
            resets += route_verify();

        if (chunks % CHUNKS_PER_SEC == 0) {
            apply_preset(stream, &cur_preset, &cur_semi);
            use_agc = prop_bool(PROP_AGC, 1);

            LOGI("STAT %lds peak=%d gain=%.1f fixups=%d clip=%d drop=%d",
                    chunks * CAP_FRAMES / OUT_RATE, peak_in, agc_gain,
                    resets, clipped, dropped);
            peak_in = 0;
            clipped = 0;
            dropped = 0;

            if (!should_run() || !call_is_active())
                break;
        }
    }

out:
    if (stream)   sonicDestroyStream(stream);
    if (cap)      alsa.pcm_close(cap);
    if (inj)      alsa.pcm_close(inj);
    free(cap_buf);
    free(pcm_in);
    free(sonic_out);
    free(inj_buf);
    route_teardown();
    LOGI("SESSION end");
}

/* ── Entry point ──────────────────────────────────────────────────────────── */

static int load_alsa(void)
{
    void *lib = dlopen("libtinyalsa.so", RTLD_NOW);
    if (!lib) {
        LOGE("dlopen libtinyalsa.so: %s", dlerror());
        return -1;
    }

#define LOAD(sym)                                                   \
    alsa.sym = (fn_##sym)dlsym(lib, #sym);                          \
    if (!alsa.sym) {                                                \
        LOGE("dlsym %s", #sym);                                     \
        return -1;                                                  \
    }

    LOAD(pcm_open)
    LOAD(pcm_close)
    LOAD(pcm_is_ready)
    LOAD(pcm_read)
    LOAD(pcm_write)
    LOAD(pcm_frames_to_bytes)
    LOAD(pcm_get_error)
    LOAD(mixer_open)
    LOAD(mixer_close)
    LOAD(mixer_get_num_ctls)
    LOAD(mixer_get_ctl)
    LOAD(mixer_get_ctl_by_name)
    LOAD(mixer_ctl_get_name)
    LOAD(mixer_ctl_get_num_values)
    LOAD(mixer_ctl_get_value)
    LOAD(mixer_ctl_set_value)
    LOAD(mixer_ctl_set_enum_by_string)
#undef LOAD

    return 0;
}

int main(int argc, char **argv)
{
    int once = (argc > 1 && !strcmp(argv[1], "--once"));

    signal(SIGINT, on_sig);
    signal(SIGTERM, on_sig);
    signal(SIGHUP, on_sig);
    signal(SIGPIPE, SIG_IGN);
    setvbuf(stderr, NULL, _IOLBF, 0);

    if (load_alsa() != 0)
        return 1;

    g_mixer = alsa.mixer_open(CARD);
    if (!g_mixer) {
        LOGE("mixer_open card %d: %s", CARD, strerror(errno));
        return 1;
    }

    LOGI("READY %u mixer controls, %d presets",
            alsa.mixer_get_num_ctls(g_mixer), NUM_PRESETS);

    /* The loop has one 32 ms capture period of slack, and the whole point is to
     * never miss one. A low real-time priority is enough to win against
     * ordinary threads without ever competing with the HAL's own (which run far
     * higher), and init gives this service none of its own. */
    struct sched_param sp = { .sched_priority = 2 };
    if (sched_setscheduler(0, SCHED_FIFO, &sp) != 0)
        LOGW("sched_setscheduler SCHED_FIFO: %s", strerror(errno));

    int backoff_ms = 1000;

    while (g_running) {
        if (should_run() && call_is_active()) {
            time_t started = time(NULL);
            run_session();
            /* A session that dies within a second or two means the route is
             * already gone even though the mixer still claims otherwise. Back
             * off instead of hammering the HAL once a second. */
            if (time(NULL) - started < 2) {
                if (backoff_ms < 32000)
                    backoff_ms *= 2;
            } else {
                /* It ran, so the call is real and the session died under us —
                 * most likely the HAL rebuilding the route. Come back fast:
                 * every millisecond here is a millisecond of the real voice
                 * going out unmuted. */
                backoff_ms = 200;
            }
            if (once)
                break;
        } else {
            backoff_ms = 1000;
        }
        /* Nothing to do: polling is far cheaper than a telephony listener
         * and costs nothing while idle. */
        usleep((useconds_t)backoff_ms * 1000);
    }

    route_teardown();
    alsa.mixer_close(g_mixer);
    LOGI("EXIT");
    return 0;
}
