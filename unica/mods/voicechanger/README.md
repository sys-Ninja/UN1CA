# UN1CA Hardware/HAL-Level Voice Changer Engine

## Overview & Background
In standard UN1CA ROM (branch `sixteen` / Android 16 / One UI 8), the Voice Changer feature was initially hooked inside Java `android.media.AudioRecord` (`VoiceChangerAudioRecordHook.smali` in `framework.jar`).

While this worked for standard Java-based recording applications (like Telegram and Messenger), it completely **failed** for applications that use native C/C++ audio engines (such as **WhatsApp**, **VoLTE/GSM phone calls**, **Discord**, and **Games**), because these native apps use Oboe / `libaudioclient` to connect directly to the Binder audio server (`audioserver` / `AudioFlinger`), bypassing Java `AudioRecord` entirely.

Furthermore, the secondary daemon (`vc_daemon`) operating via TinyALSA mixer controls (`TX_DEC1`, `MultiMedia5`, etc.) was prone to device-specific audio mixer route conflicts across different Snapdragon / Exynos SoC revisions.

---

## The Solution: OS/HAL Capture Layer Interception
This engine implements interception at the **Audio Hardware Abstraction Layer (HAL) level** inside Android's 64-bit `audioserver`.

### Audio Pipeline Architecture:
```
[Microphone Hardware]
       │
       ▼
[Kernel ALSA Driver: /dev/snd/pcmC0D*c]
       │
       ▼
[Vendor Audio HAL (32-bit): audio.primary.lahaina.so]
       │  (Fast Message Queue / HIDL 6.0)
       ▼
[System Audio Server (64-bit): audioserver / libaudiohal@6.0.so]
       │
       ★ StreamInHalHidl::read() intercepts raw 16-bit PCM audio ★
       ★ Real-time in-place pitch shifting via Sonic + Biquad DSP ★
       │
       ▼
[AudioFlinger::RecordThread (audioserver)]
       │
       ├──> WhatsApp (Voice notes & VoIP calls) [Native Oboe]
       ├──> Phone Calls (VoLTE / GSM)
       ├──> Telegram & Messenger [AudioRecord]
       ├──> System Voice Recorder
       └──> In-game Voice Chats & Discord
```

---

## Technical Mechanism
1. **Dynamic Loading:**
   `/system/lib64/libvoicechanger.so` is registered in `/system/etc/audio_effects_common.conf` and loaded automatically by `audioserver` during startup.

2. **Vtable Hooking:**
   On library initialization (`__attribute__((constructor))`), `libvoicechanger.so`:
   - Inspects `/proc/self/maps` to find the runtime base address of `libaudiohal@6.0.so`.
   - Locates the virtual method table (vtable) slot for `StreamInHalHidl::read` at offset `base + 0x392f8`.
   - Modifies memory protection (`mprotect(PROT_READ | PROT_WRITE)`), saves the original function pointer (`base + 0x29388`), and overwrites the vtable slot with `hooked_read`.
   - Restores memory protection to `PROT_READ`.

3. **In-Place DSP Processing:**
   When any app records audio:
   - `hooked_read()` calls the original `StreamInHalHidl::read()`.
   - When the read returns successfully with audio samples, it checks:
     - `persist.sys.unica.vc.enabled`: If `false`, returns raw audio immediately (0 latency, 0 CPU overhead).
     - `persist.sys.unica.vc.preset`: Reads current preset (`soft_girl`, `girl`, `chipmunk`, `giant`, `helium`, `cyborg`, or custom).
     - `persist.sys.unica.vc.semitones`: Reads custom pitch semi-tone shift if set.
   - Feeds the raw PCM into Bill Cox's `Sonic` pitch/tempo engine, processes through 4-stage Biquad filters (Highpass, Notch, Formant Peaking, Highshelf Air), applies soft-limiting, and copies the modified samples back into the caller's buffer.
   - A circular FIFO maintains exact sample counts and frame alignment, preventing buffer underruns or audio clipping.

---

## Supported System Properties & UN1CA Integration
This library uses the exact same properties as UN1CA Settings / Quick Settings tiles:

| Property | Values | Description |
| :--- | :--- | :--- |
| `persist.sys.unica.vc.enabled` | `true` / `false` | Master toggle switch. Instant on/off. |
| `persist.sys.unica.vc.preset` | `soft_girl`, `girl`, `chipmunk`, `giant`, `helium`, `cyborg`, `normal` | Selected voice preset. |
| `persist.sys.unica.vc.semitones` | Float string (e.g. `0`, `5.0`, `-4.0`) | Pitch shift in semitones for custom preset. |
| `persist.sys.unica.vc.global` | `false` | Set to `false` in `build.prop` so Java `framework.jar` does not double-shift. |

---

## Repository Files
- `libvoicechanger.so`: Precompiled 64-bit ARM64 shared library.
- `voicechanger_main.cpp`: Core hook, property reader, and DSP dispatcher.
- `sonic.c` / `sonic.h`: High quality pitch/tempo DSP engine.
- `build.sh`: Automated compilation script using Android NDK Clang.

---

## How to Integrate into UN1CA ROM Source
1. Copy `libvoicechanger.so` (or compile via `Android.bp` / `Android.mk`) into `/system/lib64/libvoicechanger.so`.
2. In `build.prop` or `default.prop`:
   ```properties
   persist.sys.unica.vc.global=false
   ```
   *(Setting `vc.global=false` disables the old Java-level `AudioRecord` hook in `framework.jar`, letting the HAL engine handle 100% of apps without double-pitching).*
3. That's it! All UN1CA UI switches, Quick Settings tiles, and preset selectors work out-of-the-box.
