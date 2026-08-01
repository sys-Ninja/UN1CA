/*
 * ca_daemon — the audio half of AI call answering.
 *
 * It owns nothing but the audio path. All the thinking (speech recognition,
 * the model, speech synthesis) lives in the Settings-side engine, which talks
 * to this process over two abstract unix sockets. Keeping the split there
 * means the root part stays small enough to audit and never needs network
 * access.
 *
 *   modem RX ── INCALL_RECORD_RX ── MultiMedia6 (pcm dev 34, 48 kHz)
 *                                        │  decimate 3:1
 *                                        ▼
 *                              @unica_ca_dl   → engine → STT → model
 *                                                              │ TTS
 *                              @unica_ca_ul   ← engine ────────┘
 *                                        │
 *   Incall_Music ── MultiMedia1 ── pcm dev 0, 8 kHz ── modem TX
 *
 * The injection path and the mic mute are byte-for-byte the ones vc_daemon
 * already proves on this device: `Incall_Music Audio Mixer MultiMedia1` into
 * card 0 device 0 at 8 kHz, and `TX_DEC0/1 Volume` = 0 to silence the room
 * without tearing down the TX DMA the injection rides on.
 *
 * The downlink tap is the one piece vc_daemon never needed, so the control
 * names are probed from a candidate list at runtime and the winner is logged.
 * A capture failure is not fatal: the daemon keeps the uplink alive so the
 * assistant can still speak, it just goes deaf.
 *
 * Properties:
 *   persist.sys.unica.ca.session  bool  set by the engine for the call it answers
 *   persist.sys.unica.ca.mute     bool  silence the user's mic (default true)
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <dlfcn.h>
#include <errno.h>
#include <stdarg.h>
#include <time.h>
#include <fcntl.h>
#include <poll.h>
#include <pthread.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/system_properties.h>
#include <android/log.h>

#define LOG_TAG "ca_daemon"

__attribute__((format(printf, 2, 3)))
static void ca_log(int prio, const char *fmt, ...)
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

#define LOGI(...) ca_log(ANDROID_LOG_INFO, __VA_ARGS__)
#define LOGW(...) ca_log(ANDROID_LOG_WARN, __VA_ARGS__)
#define LOGE(...) ca_log(ANDROID_LOG_ERROR, __VA_ARGS__)

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
typedef struct mixer_ctl * (*fn_mixer_get_ctl_by_name)(struct mixer *, const char *);
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
    fn_mixer_get_ctl_by_name        mixer_get_ctl_by_name;
    fn_mixer_ctl_get_num_values     mixer_ctl_get_num_values;
    fn_mixer_ctl_get_value          mixer_ctl_get_value;
    fn_mixer_ctl_set_value          mixer_ctl_set_value;
    fn_mixer_ctl_set_enum_by_string mixer_ctl_set_enum_by_string;
} alsa;

/* ── Audio path constants (a52sxq / lahaina-yupikidp) ─────────────────────── */

#define CARD            0
#define DEV_INJECT      0      /* MultiMedia1 → Incall_Music, proven by vc_daemon */
#define DEV_DOWNLINK    34     /* MultiMedia6, the frontend vc_daemon leaves free */

#define CAP_RATE        48000
#define STT_RATE        16000  /* what every speech recogniser wants */
#define CAP_DECIM       (CAP_RATE / STT_RATE)
#define OUT_RATE        8000   /* the incall_music path is hard-wired to 8 kHz */

#define STT_FRAMES      320                    /* 20 ms at 16 kHz */
#define CAP_IN_FRAMES   (STT_FRAMES * CAP_DECIM)
#define INJ_FRAMES      1024                   /* 128 ms, matches vc_daemon */

#define TX_DEC_MUTED    0
#define TX_DEC_DEFAULT  96

/* Two calls' worth of headroom so a slow TTS never underruns mid-sentence. */
#define RING_FRAMES     (OUT_RATE * 8)

#define SOCK_DOWNLINK   "unica_ca_dl"
#define SOCK_UPLINK     "unica_ca_ul"

#define PROP_SESSION    "persist.sys.unica.ca.session"
#define PROP_MUTE       "persist.sys.unica.ca.mute"

/* ── Properties ───────────────────────────────────────────────────────────── */

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

/* ── Mixer helpers ────────────────────────────────────────────────────────── */

static struct mixer *g_mixer;

static int ctl_exists(const char *name)
{
    return alsa.mixer_get_ctl_by_name(g_mixer, name) != NULL;
}

/* Several of these controls carry more than one value, so write every value
 * rather than just index 0 — the same reason vc_daemon does. */
static int ctl_set_int(const char *name, int value)
{
    struct mixer_ctl *c = alsa.mixer_get_ctl_by_name(g_mixer, name);
    if (!c) {
        LOGW("mixer control not found: %s", name);
        return -1;
    }
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
    struct mixer_ctl *c = alsa.mixer_get_ctl_by_name(g_mixer, name);
    if (!c)
        return -1;
    return alsa.mixer_ctl_set_enum_by_string(c, value) == 0 ? 0 : -1;
}

static int ctl_get_int(const char *name, int def)
{
    struct mixer_ctl *c = alsa.mixer_get_ctl_by_name(g_mixer, name);
    return c ? alsa.mixer_ctl_get_value(c, 0) : def;
}

/* Same probe vc_daemon settled on: only the VoiceMMode mixers tell the truth
 * about a live VoLTE call. TX_AIF1_CAP stays On long after a hang-up. */
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

/* The downlink tap is the one route vc_daemon never had to find, so pick the
 * first name the kernel actually exposes instead of hard-coding a guess. */
static const char *g_dl_ctl;

static const char *find_downlink_ctl(void)
{
    static const char *candidates[] = {
        "MultiMedia6 Mixer INCALL_RECORD_RX",
        "MultiMedia6 Mixer VOC_REC_DL",
        "MultiMedia6 Mixer SLIM_6_TX",
        "MultiMedia6 Mixer AFE_PCM_TX",
    };
    for (size_t i = 0; i < sizeof(candidates) / sizeof(candidates[0]); i++) {
        if (ctl_exists(candidates[i])) {
            LOGI("downlink tap: %s", candidates[i]);
            return candidates[i];
        }
    }
    LOGW("no downlink mixer control found; the assistant will not hear the caller");
    return NULL;
}

/* ── Uplink ring buffer ───────────────────────────────────────────────────── */

static short g_ring[RING_FRAMES];
static int g_ring_head, g_ring_tail;
static pthread_mutex_t g_ring_lock = PTHREAD_MUTEX_INITIALIZER;

static void ring_reset(void)
{
    pthread_mutex_lock(&g_ring_lock);
    g_ring_head = g_ring_tail = 0;
    pthread_mutex_unlock(&g_ring_lock);
}

static void ring_push(const short *data, int frames)
{
    pthread_mutex_lock(&g_ring_lock);
    for (int i = 0; i < frames; i++) {
        int next = (g_ring_head + 1) % RING_FRAMES;
        if (next == g_ring_tail)
            break;              /* engine is running ahead of the call; drop */
        g_ring[g_ring_head] = data[i];
        g_ring_head = next;
    }
    pthread_mutex_unlock(&g_ring_lock);
}

/* Always returns `frames`, padded with silence. The injection PCM must never
 * be starved or the HAL tears the route down. */
static int ring_pull(short *out, int frames)
{
    int got = 0;
    pthread_mutex_lock(&g_ring_lock);
    while (got < frames && g_ring_tail != g_ring_head) {
        out[got++] = g_ring[g_ring_tail];
        g_ring_tail = (g_ring_tail + 1) % RING_FRAMES;
    }
    pthread_mutex_unlock(&g_ring_lock);
    memset(out + got, 0, (size_t)(frames - got) * sizeof(short));
    return got;
}

/* ── Sockets ──────────────────────────────────────────────────────────────── */

/* Abstract namespace: no file to create, no SELinux label to get wrong, and
 * the socket disappears with the process. */
static int listen_abstract(const char *name)
{
    struct sockaddr_un addr;
    int fd = socket(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0);
    if (fd < 0) {
        LOGE("socket %s: %s", name, strerror(errno));
        return -1;
    }

    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    addr.sun_path[0] = '\0';
    snprintf(addr.sun_path + 1, sizeof(addr.sun_path) - 1, "%s", name);
    socklen_t len = (socklen_t)(offsetof(struct sockaddr_un, sun_path) + 1 + strlen(name));

    if (bind(fd, (struct sockaddr *)&addr, len) != 0 || listen(fd, 1) != 0) {
        LOGE("bind/listen @%s: %s", name, strerror(errno));
        close(fd);
        return -1;
    }
    LOGI("listening on @%s", name);
    return fd;
}

static int g_dl_listen = -1, g_ul_listen = -1;
static int g_dl_client = -1, g_ul_client = -1;
static pthread_mutex_t g_client_lock = PTHREAD_MUTEX_INITIALIZER;

static void drop_client(int *slot)
{
    pthread_mutex_lock(&g_client_lock);
    if (*slot >= 0) {
        close(*slot);
        *slot = -1;
    }
    pthread_mutex_unlock(&g_client_lock);
}

/* One thread accepts on both listeners and drains the uplink client, so the
 * engine can connect and reconnect at any point in the call. */
static volatile sig_atomic_t g_running = 1;

static void *net_thread(void *unused)
{
    (void)unused;
    short buf[512];

    while (g_running) {
        struct pollfd fds[3];
        int n = 0;

        fds[n].fd = g_dl_listen; fds[n].events = POLLIN; n++;
        fds[n].fd = g_ul_listen; fds[n].events = POLLIN; n++;

        pthread_mutex_lock(&g_client_lock);
        int ul = g_ul_client;
        pthread_mutex_unlock(&g_client_lock);
        int ul_slot = -1;
        if (ul >= 0) {
            ul_slot = n;
            fds[n].fd = ul; fds[n].events = POLLIN; n++;
        }

        if (poll(fds, (nfds_t)n, 500) <= 0)
            continue;

        if (fds[0].revents & POLLIN) {
            int c = accept(g_dl_listen, NULL, NULL);
            if (c >= 0) {
                /* Never let a stalled reader block the capture loop. */
                fcntl(c, F_SETFL, O_NONBLOCK);
                drop_client(&g_dl_client);
                pthread_mutex_lock(&g_client_lock);
                g_dl_client = c;
                pthread_mutex_unlock(&g_client_lock);
                LOGI("downlink client connected");
            }
        }

        if (fds[1].revents & POLLIN) {
            int c = accept(g_ul_listen, NULL, NULL);
            if (c >= 0) {
                drop_client(&g_ul_client);
                ring_reset();
                pthread_mutex_lock(&g_client_lock);
                g_ul_client = c;
                pthread_mutex_unlock(&g_client_lock);
                LOGI("uplink client connected");
            }
        }

        if (ul_slot >= 0 && (fds[ul_slot].revents & (POLLIN | POLLHUP | POLLERR))) {
            ssize_t got = read(ul, buf, sizeof(buf));
            if (got > 0)
                ring_push(buf, (int)(got / (ssize_t)sizeof(short)));
            else if (got == 0 || (got < 0 && errno != EAGAIN && errno != EINTR)) {
                LOGI("uplink client gone");
                drop_client(&g_ul_client);
            }
        }
    }
    return NULL;
}

static void send_downlink(const short *data, int frames)
{
    pthread_mutex_lock(&g_client_lock);
    int fd = g_dl_client;
    pthread_mutex_unlock(&g_client_lock);
    if (fd < 0)
        return;

    ssize_t want = (ssize_t)frames * (ssize_t)sizeof(short);
    ssize_t sent = send(fd, data, (size_t)want, MSG_NOSIGNAL);
    if (sent < 0 && errno != EAGAIN && errno != EWOULDBLOCK && errno != EINTR) {
        LOGI("downlink client gone");
        drop_client(&g_dl_client);
    }
}

/* ── Session ──────────────────────────────────────────────────────────────── */

static struct pcm *g_inj;
static volatile sig_atomic_t g_session = 0;

/* Paced entirely by the blocking pcm_write, exactly like vc_daemon's inject
 * side. Silence keeps the route warm between sentences. */
static void *inject_thread(void *unused)
{
    (void)unused;
    short buf[INJ_FRAMES];
    unsigned int bytes = alsa.pcm_frames_to_bytes(g_inj, INJ_FRAMES);

    while (g_running && g_session) {
        ring_pull(buf, INJ_FRAMES);
        if (alsa.pcm_write(g_inj, buf, bytes) != 0) {
            LOGE("pcm_write: %s", alsa.pcm_get_error(g_inj));
            break;
        }
    }
    return NULL;
}

static void route_teardown(void)
{
    /* Give the mic back to the modem first: a hang-up mid-teardown must never
     * leave the user muted on the next call. */
    ctl_set_int("TX_DEC0 Volume", TX_DEC_DEFAULT);
    ctl_set_int("TX_DEC1 Volume", TX_DEC_DEFAULT);
    if (g_dl_ctl)
        ctl_set_int(g_dl_ctl, 0);
    ctl_set_int("Incall_Music Audio Mixer MultiMedia1", 0);
}

static void run_session(void)
{
    struct pcm_config cap_cfg, inj_cfg;
    struct pcm *cap = NULL;
    short *cap_buf = NULL, *stt_buf = NULL;
    pthread_t injector;
    int injector_started = 0;
    unsigned int cap_bytes;
    long chunks = 0;
    int peak = 0, resets = 0;
    int mute = prop_bool(PROP_MUTE, 1);

    LOGI("SESSION start mute=%d", mute);
    ring_reset();

    /* Uplink first. If the assistant cannot speak there is no point muting the
     * user — the caller would hear nothing at all. */
    ctl_set_int("Incall_Music Audio Mixer MultiMedia1", 1);
    ctl_set_int("Playback 0 Volume", 8192);   /* unity, range 0..8192 */

    memset(&inj_cfg, 0, sizeof(inj_cfg));
    inj_cfg.channels     = 1;
    inj_cfg.rate         = OUT_RATE;
    inj_cfg.period_size  = INJ_FRAMES;
    inj_cfg.period_count = 2;
    inj_cfg.format       = PCM_FORMAT_S16_LE;

    g_inj = alsa.pcm_open(CARD, DEV_INJECT, PCM_OUT, &inj_cfg);
    if (!g_inj || !alsa.pcm_is_ready(g_inj)) {
        LOGE("inject pcm_open: %s", g_inj ? alsa.pcm_get_error(g_inj) : "null");
        goto out;
    }

    g_session = 1;
    if (pthread_create(&injector, NULL, inject_thread, NULL) == 0)
        injector_started = 1;

    /* Downlink tap. Optional: losing it costs the assistant its ears, not its
     * voice, so a failure here must not abort the session. */
    if (g_dl_ctl) {
        ctl_set_int(g_dl_ctl, 1);
        ctl_set_enum("INCALL_RECORD_RX Channels", "One");

        memset(&cap_cfg, 0, sizeof(cap_cfg));
        cap_cfg.channels     = 1;
        cap_cfg.rate         = CAP_RATE;
        cap_cfg.period_size  = CAP_IN_FRAMES;
        cap_cfg.period_count = 4;
        cap_cfg.format       = PCM_FORMAT_S16_LE;

        cap = alsa.pcm_open(CARD, DEV_DOWNLINK, PCM_IN, &cap_cfg);
        if (!cap || !alsa.pcm_is_ready(cap)) {
            LOGE("downlink pcm_open: %s", cap ? alsa.pcm_get_error(cap) : "null");
            if (cap) {
                alsa.pcm_close(cap);
                cap = NULL;
            }
            ctl_set_int(g_dl_ctl, 0);
        }
    }

    if (mute) {
        ctl_set_int("TX_DEC0 Volume", TX_DEC_MUTED);
        ctl_set_int("TX_DEC1 Volume", TX_DEC_MUTED);
    }

    if (!cap) {
        /* Deaf but able to speak: still useful for a fixed announcement, and
         * the loop below has nothing to read, so just idle. */
        LOGW("no downlink capture; uplink only");
        while (g_running && prop_bool(PROP_SESSION, 0) && call_is_active())
            sleep(1);
        goto out;
    }

    cap_bytes = alsa.pcm_frames_to_bytes(cap, CAP_IN_FRAMES);
    cap_buf = malloc(cap_bytes);
    stt_buf = malloc(STT_FRAMES * sizeof(short));
    if (!cap_buf || !stt_buf) {
        LOGE("out of memory");
        goto out;
    }

    LOGI("OK downlink=%u bytes/period", cap_bytes);

    while (g_running) {
        if (alsa.pcm_read(cap, cap_buf, cap_bytes) != 0) {
            LOGE("pcm_read: %s", alsa.pcm_get_error(cap));
            break;
        }

        /* 48 kHz → 16 kHz. A boxcar average of 3 puts its first null on
         * 16 kHz, which is all the anti-aliasing speech needs. */
        for (int i = 0; i < STT_FRAMES; i++) {
            int acc = 0;
            for (int k = 0; k < CAP_DECIM; k++)
                acc += cap_buf[i * CAP_DECIM + k];
            int s = acc / CAP_DECIM;
            stt_buf[i] = (short)s;
            int a = s < 0 ? -s : s;
            if (a > peak)
                peak = a;
        }

        send_downlink(stt_buf, STT_FRAMES);

        /* Housekeeping once a second: the HAL restores TX_DEC0 to its default
         * after route changes, exactly as it does under vc_daemon. */
        if (++chunks % (STT_RATE / STT_FRAMES) == 0) {
            if (mute && (ctl_get_int("TX_DEC0 Volume", 0) != TX_DEC_MUTED ||
                         ctl_get_int("TX_DEC1 Volume", 0) != TX_DEC_MUTED)) {
                ctl_set_int("TX_DEC0 Volume", TX_DEC_MUTED);
                ctl_set_int("TX_DEC1 Volume", TX_DEC_MUTED);
                resets++;
            }

            LOGI("STAT %lds peak=%d muteResets=%d", chunks * STT_FRAMES / STT_RATE,
                    peak, resets);
            peak = 0;

            if (!prop_bool(PROP_SESSION, 0) || !call_is_active())
                break;
        }
    }

out:
    g_session = 0;
    if (injector_started)
        pthread_join(injector, NULL);
    if (cap)
        alsa.pcm_close(cap);
    if (g_inj) {
        alsa.pcm_close(g_inj);
        g_inj = NULL;
    }
    free(cap_buf);
    free(stt_buf);
    route_teardown();
    LOGI("SESSION end");
}

/* ── Entry point ──────────────────────────────────────────────────────────── */

static void on_sig(int s) { (void)s; g_running = 0; }

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
    LOAD(mixer_get_ctl_by_name)
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
    pthread_t net;

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

    g_dl_ctl = find_downlink_ctl();

    g_dl_listen = listen_abstract(SOCK_DOWNLINK);
    g_ul_listen = listen_abstract(SOCK_UPLINK);
    if (g_dl_listen < 0 || g_ul_listen < 0)
        return 1;

    if (pthread_create(&net, NULL, net_thread, NULL) != 0) {
        LOGE("pthread_create net: %s", strerror(errno));
        return 1;
    }

    LOGI("READY %u mixer controls", alsa.mixer_get_num_ctls(g_mixer));

    int backoff = 1;

    while (g_running) {
        if (prop_bool(PROP_SESSION, 0) && call_is_active()) {
            time_t started = time(NULL);
            run_session();
            /* A session that dies immediately means the route is already gone
             * even though the mixer still claims otherwise. */
            if (time(NULL) - started < 2) {
                if (backoff < 32)
                    backoff *= 2;
            } else {
                backoff = 1;
            }
            if (once)
                break;
        } else {
            backoff = 1;
        }
        sleep(backoff);
    }

    g_running = 0;
    pthread_join(net, NULL);
    route_teardown();
    alsa.mixer_close(g_mixer);
    LOGI("EXIT");
    return 0;
}
