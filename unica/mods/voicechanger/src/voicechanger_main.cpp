#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <dlfcn.h>
#include <sys/mman.h>
#include <sys/system_properties.h>
#include <android/log.h>
#include <math.h>
#include <unistd.h>
#include <errno.h>
#include <pthread.h>

#include "/tmp/sonic.h"

#define TAG "VoiceChangerHAL"
#define ALOGI(...) __android_log_print(ANDROID_LOG_INFO, TAG, __VA_ARGS__)
#define ALOGW(...) __android_log_print(ANDROID_LOG_WARN, TAG, __VA_ARGS__)
#define ALOGE(...) __android_log_print(ANDROID_LOG_ERROR, TAG, __VA_ARGS__)

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

// ============================================================================
// Android Audio Effect Library Dummy Exports
// ============================================================================
extern "C" {
    int32_t VC_process(void*, void*, void*) { return 0; }
    int32_t VC_command(void*, uint32_t, uint32_t, void*, uint32_t*, void*) { return 0; }
    int32_t VC_getDescriptor(void*, void*) { return 0; }
    int32_t VCLib_Create(const void*, int32_t, int32_t, void**) { return 0; }
    int32_t VCLib_Release(void*) { return 0; }
    int32_t VCLib_GetDescriptor(const void*, void*) { return 0; }

    struct EffectInterface {
        int32_t (*process)(void*, void*, void*);
        int32_t (*command)(void*, uint32_t, uint32_t, void*, uint32_t*, void*);
        int32_t (*getDescriptor)(void*, void*);
        void* reserved;
    } gVCEffectInterface = {
        VC_process,
        VC_command,
        VC_getDescriptor,
        NULL
    };
}

// ============================================================================
// Biquad Filter (Cookbook Transposed Direct Form II)
// ============================================================================
struct Biquad {
    float b0, b1, b2, a1, a2;
    float z1, z2;

    void reset() {
        b0 = 1.0f;
        b1 = b2 = a1 = a2 = 0.0f;
        z1 = z2 = 0.0f;
    }

    float run(float in) {
        float out = b0 * in + z1;
        z1 = b1 * in - a1 * out + z2;
        z2 = b2 * in - a2 * out;
        return out;
    }

    void setHighpass(float srate, float freq, float q) {
        if (freq <= 20.0f || freq >= 0.48f * srate) {
            b0 = 1.0f; b1 = b2 = a1 = a2 = 0.0f;
            return;
        }
        double w0 = 2.0 * M_PI * freq / srate;
        double alpha = sin(w0) / (2.0 * q);
        double cosw = cos(w0);
        double a0 = 1.0 + alpha;
        b0 = (float)(((1.0 + cosw) / 2.0) / a0);
        b1 = (float)(-(1.0 + cosw) / a0);
        b2 = (float)(((1.0 + cosw) / 2.0) / a0);
        a1 = (float)(-2.0 * cosw / a0);
        a2 = (float)((1.0 - alpha) / a0);
    }

    void setPeaking(float srate, float freq, float q, float gainDb) {
        if (freq <= 20.0f || freq >= 0.48f * srate || fabsf(gainDb) < 0.1f) {
            b0 = 1.0f; b1 = b2 = a1 = a2 = 0.0f;
            return;
        }
        double A = pow(10.0, gainDb / 40.0);
        double w0 = 2.0 * M_PI * freq / srate;
        double alpha = sin(w0) / (2.0 * q);
        double cosw = cos(w0);
        double a0 = 1.0 + alpha / A;
        b0 = (float)((1.0 + alpha * A) / a0);
        b1 = (float)(-2.0 * cosw / a0);
        b2 = (float)((1.0 - alpha * A) / a0);
        a1 = (float)(-2.0 * cosw / a0);
        a2 = (float)((1.0 - alpha / A) / a0);
    }

    void setHighshelf(float srate, float freq, float gainDb) {
        if (freq <= 20.0f || freq >= 0.48f * srate || fabsf(gainDb) < 0.1f) {
            b0 = 1.0f; b1 = b2 = a1 = a2 = 0.0f;
            return;
        }
        double A = pow(10.0, gainDb / 40.0);
        double w0 = 2.0 * M_PI * freq / srate;
        double cosw = cos(w0);
        double sinw = sin(w0);
        double alpha = sinw / 2.0 * sqrt((A + 1.0/A)*(1.0/0.7071 - 1.0) + 2.0);
        double two_sqrt_A_alpha = 2.0 * sqrt(A) * alpha;

        double a0 = (A + 1.0) - (A - 1.0) * cosw + two_sqrt_A_alpha;
        b0 = (float)(A * ((A + 1.0) + (A - 1.0) * cosw + two_sqrt_A_alpha) / a0);
        b1 = (float)(-2.0 * A * ((A - 1.0) + (A + 1.0) * cosw) / a0);
        b2 = (float)(A * ((A + 1.0) + (A - 1.0) * cosw - two_sqrt_A_alpha) / a0);
        a1 = (float)(2.0 * ((A - 1.0) - (A + 1.0) * cosw) / a0);
        a2 = (float)(((A + 1.0) - (A - 1.0) * cosw - two_sqrt_A_alpha) / a0);
    }
};

static inline int16_t softLimit(float v) {
    if (v > 32767.0f) return 32767;
    if (v < -32768.0f) return -32768;
    return (int16_t)v;
}

// ============================================================================
// DSP Engine State & Presets
// ============================================================================
static sonicStream s_sonic = nullptr;
static int s_current_srate = 48000;
static int s_current_channels = 1;
static char s_current_preset[64] = "";
static float s_current_semitones = 999.0f;

static Biquad s_hpf;
static Biquad s_notch;
static Biquad s_formant;
static Biquad s_air;

#define FIFO_MAX_SAMPLES 16384
static int16_t s_fifo[FIFO_MAX_SAMPLES];
static int s_fifo_count = 0;

static void push_fifo(const int16_t* samples, int count) {
    if (s_fifo_count + count > FIFO_MAX_SAMPLES) {
        int drop = (s_fifo_count + count) - FIFO_MAX_SAMPLES;
        memmove(s_fifo, s_fifo + drop, (s_fifo_count - drop) * sizeof(int16_t));
        s_fifo_count -= drop;
    }
    memcpy(s_fifo + s_fifo_count, samples, count * sizeof(int16_t));
    s_fifo_count += count;
}

static int pop_fifo(int16_t* out, int count) {
    if (s_fifo_count <= 0) return 0;
    int available = (s_fifo_count < count) ? s_fifo_count : count;
    memcpy(out, s_fifo, available * sizeof(int16_t));
    if (s_fifo_count > available) {
        memmove(s_fifo, s_fifo + available, (s_fifo_count - available) * sizeof(int16_t));
    }
    s_fifo_count -= available;
    return available;
}

static void update_preset(const char* preset, float semitones, int sampleRate, int channels) {
    bool rateOrChannelChanged = (sampleRate != s_current_srate || channels != s_current_channels);
    bool presetChanged = (strcmp(preset, s_current_preset) != 0 || fabsf(semitones - s_current_semitones) > 0.01f);

    if (!rateOrChannelChanged && !presetChanged && s_sonic != nullptr) {
        return;
    }

    if (s_sonic != nullptr && rateOrChannelChanged) {
        sonicDestroyStream(s_sonic);
        s_sonic = nullptr;
        s_fifo_count = 0;
    }

    s_current_srate = sampleRate;
    s_current_channels = channels;
    strncpy(s_current_preset, preset, sizeof(s_current_preset) - 1);
    s_current_semitones = semitones;

    if (s_sonic == nullptr) {
        s_sonic = sonicCreateStream(sampleRate, channels);
        sonicSetSpeed(s_sonic, 1.0f);
    }

    float pitch = 1.0f;
    float hpfFreq = 0.0f;
    float notchFreq = 0.0f, notchQ = 1.0f, notchGain = 0.0f;
    float formantFreq = 0.0f, formantQ = 1.0f, formantGain = 0.0f;
    float airFreq = 0.0f, airGain = 0.0f;

    if (strcmp(preset, "soft_girl") == 0) {
        pitch = 1.52f;
        hpfFreq = 210.0f;
        notchFreq = 520.0f; notchQ = 1.5f; notchGain = -1.5f;
        formantFreq = 2450.0f; formantQ = 1.3f; formantGain = 4.0f;
        airFreq = 3300.0f; airGain = -3.5f;
    } else if (strcmp(preset, "girl") == 0) {
        pitch = 1.44f;
        hpfFreq = 195.0f;
        notchFreq = 480.0f; notchQ = 1.4f; notchGain = -1.5f;
        formantFreq = 2300.0f; formantQ = 1.2f; formantGain = 4.0f;
        airFreq = 3200.0f; airGain = -3.0f;
    } else if (strcmp(preset, "chipmunk") == 0) {
        pitch = 1.95f;
        hpfFreq = 300.0f;
        formantFreq = 2800.0f; formantQ = 1.2f; formantGain = 3.0f;
    } else if (strcmp(preset, "giant") == 0) {
        pitch = 0.60f;
        hpfFreq = 50.0f;
        notchFreq = 100.0f; notchQ = 1.0f; notchGain = -4.0f;
        formantFreq = 2600.0f; formantQ = 0.8f; formantGain = 6.0f;
    } else if (strcmp(preset, "helium") == 0) {
        pitch = 1.55f;
        hpfFreq = 220.0f;
    } else if (strcmp(preset, "cyborg") == 0) {
        pitch = 0.80f;
        hpfFreq = 80.0f;
        notchFreq = 1800.0f; notchQ = 0.5f; notchGain = 5.0f;
        formantFreq = 900.0f; formantQ = 0.5f; formantGain = 5.0f;
        airFreq = 2500.0f; airGain = 5.0f;
    } else if (strcmp(preset, "custom") == 0 || fabsf(semitones) > 0.01f) {
        pitch = (float)pow(2.0, (double)semitones / 12.0);
        if (semitones > 0.0f) {
            hpfFreq = fminf(15.0f * semitones + 100.0f, 300.0f);
            formantFreq = fminf(100.0f * semitones + 1500.0f, 2500.0f);
            formantGain = fminf(0.5f * semitones, 4.0f);
            notchGain = -1.5f;
        } else if (semitones < -1.0f) {
            hpfFreq = 70.0f;
            formantFreq = 140.0f;
            formantGain = fminf(-semitones * 0.6f, 5.0f);
            notchFreq = 2500.0f; notchQ = 1.2f; notchGain = -2.5f;
        }
    } else {
        pitch = 1.0f;
    }

    sonicSetPitch(s_sonic, pitch);
    s_hpf.setHighpass((float)sampleRate, hpfFreq, 0.7071f);
    s_notch.setPeaking((float)sampleRate, notchFreq, notchQ, notchGain);
    s_formant.setPeaking((float)sampleRate, formantFreq, formantQ, formantGain);
    s_air.setHighshelf((float)sampleRate, airFreq, airGain);

    ALOGI("DSP configured: preset=%s, pitch=%.2f, semi=%.1f, srate=%d, ch=%d",
          preset, pitch, semitones, sampleRate, channels);
}

static void apply_voice_changer(void* this_ptr, void* buffer, size_t bytesRead) {
    char enabled_prop[PROP_VALUE_MAX] = {0};
    __system_property_get("persist.sys.unica.vc.enabled", enabled_prop);
    if (strcmp(enabled_prop, "true") != 0 && strcmp(enabled_prop, "1") != 0) {
        return;
    }

    char preset[PROP_VALUE_MAX] = {0};
    __system_property_get("persist.sys.unica.vc.preset", preset);
    if (strlen(preset) == 0 || strcmp(preset, "normal") == 0) {
        return;
    }

    char semi_str[PROP_VALUE_MAX] = {0};
    float semitones = 0.0f;
    if (__system_property_get("persist.sys.unica.vc.semitones", semi_str) > 0) {
        semitones = strtof(semi_str, NULL);
    }

    size_t frameSize = *(size_t*)((char*)this_ptr + 0x80);
    int channels = (frameSize == 4) ? 2 : 1;
    int sampleRate = 48000;

    update_preset(preset, semitones, sampleRate, channels);

    int numFrames = (int)(bytesRead / (channels * sizeof(int16_t)));
    if (numFrames <= 0) return;

    int16_t* pcm = (int16_t*)buffer;
    sonicWriteShortToStream(s_sonic, pcm, numFrames);

    int avail = sonicSamplesAvailable(s_sonic);
    while (avail > 0) {
        int16_t tmp[1024 * 2];
        int to_read = (avail > 1024) ? 1024 : avail;
        int read_frames = sonicReadShortFromStream(s_sonic, tmp, to_read);
        if (read_frames <= 0) break;

        int total_samples = read_frames * channels;
        for (int i = 0; i < total_samples; i++) {
            float s = (float)tmp[i];
            s = s_hpf.run(s);
            s = s_notch.run(s);
            s = s_formant.run(s);
            s = s_air.run(s);
            tmp[i] = softLimit(s);
        }

        push_fifo(tmp, total_samples);
        avail = sonicSamplesAvailable(s_sonic);
    }

    int needed_samples = numFrames * channels;
    int popped = pop_fifo(pcm, needed_samples);
    if (popped < needed_samples) {
        memset(pcm + popped, 0, (needed_samples - popped) * sizeof(int16_t));
    }
}

// ============================================================================
// Virtual Method Hook for StreamInHalHidl::read
// ============================================================================
typedef int32_t (*read_fn_t)(void* this_ptr, void* buffer, size_t bytes, size_t* read);
static read_fn_t g_real_read = nullptr;

static int32_t hooked_read(void* this_ptr, void* buffer, size_t bytes, size_t* read) {
    int32_t status = g_real_read(this_ptr, buffer, bytes, read);
    if (status == 0 && read && *read > 0 && buffer) {
        apply_voice_changer(this_ptr, buffer, *read);
    }
    return status;
}

static bool try_hook() {
    FILE* fp = fopen("/proc/self/maps", "r");
    if (!fp) return false;

    char line[512];
    uintptr_t base = 0;
    while (fgets(line, sizeof(line), fp)) {
        if (strstr(line, "libaudiohal@6.0.so") && strstr(line, "r--p 00000000")) {
            base = strtoull(line, NULL, 16);
            break;
        }
    }
    fclose(fp);

    if (!base) return false;

    uintptr_t vtable_slot = base + 0x392f8;
    uintptr_t expected_read = base + 0x29388;
    uintptr_t current_val = *(uintptr_t*)vtable_slot;

    if (current_val == (uintptr_t)hooked_read) {
        ALOGI("Already hooked, skipping");
        return true;
    }

    if (current_val != expected_read) {
        ALOGW("vtable slot value mismatch (got %p, expected %p), aborting",
              (void*)current_val, (void*)expected_read);
        return false;
    }

    uintptr_t page_start = vtable_slot & ~0xFFFULL;
    if (mprotect((void*)page_start, 0x1000, PROT_READ | PROT_WRITE) != 0) {
        ALOGE("mprotect PROT_WRITE failed: %s", strerror(errno));
        return false;
    }

    g_real_read = (read_fn_t)*(void**)vtable_slot;
    *(void**)vtable_slot = (void*)hooked_read;

    mprotect((void*)page_start, 0x1000, PROT_READ);

    ALOGI("VoiceChanger HAL Hook successfully installed! %p -> %p (orig %p)",
          (void*)vtable_slot, (void*)hooked_read, (void*)g_real_read);
    return true;
}

static void* hook_thread_fn(void*) {
    for (int i = 0; i < 40; i++) {
        if (try_hook()) break;
        usleep(50000); // 50ms
    }
    return NULL;
}

__attribute__((constructor))
static void on_load() {
    ALOGI("libvoicechanger loaded into audioserver (pid %d)", getpid());
    if (!try_hook()) {
        pthread_t tid;
        pthread_create(&tid, NULL, hook_thread_fn, NULL);
        pthread_detach(tid);
    }
}
