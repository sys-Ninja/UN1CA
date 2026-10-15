# توثيق ميزة حقن تسجيلات الصوت في المايك (Mic Audio Injection)

> **الفرع:** `sixteen-mic-inject`  
> **النظام:** UN1CA ROM (Android 16 / One UI 7 - Samsung Galaxy A52s)  
> **التاريخ:** أكتوبر 2026

---

## 1. الفكرة والهدف من الميزة (Overview)

ميزة **Virtual Microphone Audio Injection** مصممة لحل مشكلة إرسال التسجيلات الصوتية في تطبيقات المحادثة (مثل WhatsApp، Telegram، Messenger، إلخ).  
بدلاً من إرسال الملفات الصوتية كملفات ميديا مسبقة التسجيل (Audio Files مع مشغل صوت)، تتيح هذه الميزة حقن أي ملف صوتي (من ElevenLabs، الذكاء الاصطناعي، أو تسجيل مسبق) مباشرة في مسار الميكروفون (`AudioRecord`).

### النتيجة للمستلم:
* يظهر له أنك تسجل صوتاً في نفس اللحظة (`Recording...`).
* يصل الصوت كـ **Voice Note (PTT) خضراء أصلية** مع Waveform كأنها سُجلت بالمايك حالا.
* **جودة صوت نقية 100% استوديو** بدون أي ضوضاء محيطة أو تشويش.

---

## 2. المعمارية التقنية وطريقة العمل (Technical Architecture)

```
[مشاركة ملف صوت من أي تطبيق (ElevenLabs, Files, WhatsApp)]
                      │
                      ▼ (Intent.ACTION_SEND)
       [AudioInjectShareActivity.smali]
                      │
        يستدعي: [AudioDecoder.smali]
                      │ (فك الضغط عبر MediaCodec إلى 16-bit PCM WAV)
                      ▼
   يُحفظ في: /sdcard/Recordings/unica_inject.wav
                      │
          تفعيل الميزة تلقائياً:
    persist.sys.unica.vc.inject = "true"
                      │
         إشعار Toast للمستخدم:
     "💉 تم تجهيز الصوت للحقن! سجل ريكورد الآن"
                      │
                      ▼
   [المستخدم يفتح واتساب ويدوس زرار الريكورد]
                      │
           AudioRecord.read()
                      │
                      ▼
     [VoiceChangerAudioRecordHook.smali]
                      │
                      ▼
            [AudioInjector.smali]
       ┌──────────────┴──────────────┐
       ▼                             ▼
[كتم المايك الحقيقي 100%]    [تشغيل الصوت في سبيكر الهاتف]
       │                    (User Hears Audio in Real-Time)
       ▼                             │
[ضخ بايتات الصوت لواتساب]            │
       │                             │
       └──────────────┬──────────────┘
                      │
                      ▼
             [انتهاء الصوت (EOF)]
                      ├── 1. سبيكر الهاتف يسكت (إشارة لرفع الإصبع).
                      ├── 2. استمرار كتم المايك وضخ سكوت رقمي (0s).
                      ├── 3. إيقاف الميزة أوتوماتيكياً:
                      │      persist.sys.unica.vc.inject = "false"
                      └── 4. عودة المايك لحالته الطبيعية فوراً.
```

---

## 3. قائمة الملفات والمسارات المعدلة (Modified Files & Paths)

### أ) إعدادات الروم وواجهة المستخدم (`SecSettings.apk`):
1. **`unica/mods/settings/SecSettings.apk/res/values/strings.xml`**:
   * إضافة نصوص الميزة باللغة الإنجليزية (`unica_vc_inject_title`, `unica_vc_inject_summary`, `unica_vc_inject_share_title`, `unica_vc_inject_ready_toast`).
2. **`unica/mods/settings/SecSettings.apk/res/values-ar/strings.xml`**:
   * إضافة نصوص الميزة باللغة العربية (`حقن تسجيل الصوت في المايك`, `حقن في الريكورد 💉`, إلخ).
3. **`unica/mods/settings/SecSettings.apk/res/xml/unica_voicechanger_settings.xml`**:
   * إضافة عنصر `SecSwitchPreference` باسم `unica_vc_inject`.
4. **`unica/mods/settings/SecSettings.apk/smali_classes4/io/mesalabs/unica/settings/voicechanger/VoiceChangerInjectPreferenceController.smali`**:
   * كود التحكم بسويتش الإعدادات (قراءة وكتابة الخاصية `persist.sys.unica.vc.inject`).
5. **`unica/mods/settings/SecSettings.apk/AndroidManifest.xml`**:
   * تسجيل `AudioInjectShareActivity` لاستقبال `Intent.ACTION_SEND` بنوع `audio/*`.

### ب) فك الضغط التلقائي والاستقبال (`SecSettings.apk`):
6. **`unica/mods/settings/SecSettings.apk/smali_classes4/io/mesalabs/unica/settings/voicechanger/AudioDecoder.smali`**:
   * محرك فك ضغط شامل يعتمد على `MediaExtractor` و `MediaCodec` لتحويل أي صيغة صوتية مضغوطة (`.mp3`, `.ogg`, `.opus`, `.m4a`, `.aac`, `.flac`) إلى ملف WAV نقي بصيغة 16-bit PCM uncompressed.
7. **`unica/mods/settings/SecSettings.apk/smali_classes4/io/mesalabs/unica/settings/voicechanger/AudioInjectShareActivity.smali`**:
   * واجهة شفافة سريعة تستقبل الصوت المشارك، تستدعي `AudioDecoder` لحفظه في `/sdcard/Recordings/unica_inject.wav`، وتفعل الميزة وتظهر إشعار Toast للمستخدم ثم تغلق نفسها فوراً.

### ج) محرك اعتراض وحقن الصوت في النظام (`framework.jar`):
8. **`unica/mods/settings/smali_framework/smali_classes6/io/mesalabs/unica/audio/VoiceChangerAudioRecordHook.smali`**:
   * تحديث دالة `isGlobalActive()` لتنشيط اعتراض الصوت إذا كانت `persist.sys.unica.vc.inject` مفعّلة.
9. **`unica/mods/settings/smali_framework/smali_classes6/io/mesalabs/unica/audio/VoiceChangerAudioRecordHook$Session.smali`**:
   * توجيه تدفق قراءة الصوت إلى `AudioInjector` في حالة الحقن، والحفاظ التام على كود الـ Voice Changer القديم (`Sonic` و `Biquad`) دون أي مساس في حالة عدم الحقن.
10. **`unica/mods/settings/smali_framework/smali_classes6/io/mesalabs/unica/audio/AudioInjector.smali`**:
    * المحرك الأساسي:
      * فتح ملف الصوت المحقون.
      * تهيئة `AudioTrack` على السبيكر المدمج (`STREAM_MUSIC`) لتمكين المراقبة اللحظية (Audio Monitoring).
      * قراءة عينات PCM وضخها في مصفوفة التطبيق المتصل بالمايك.
      * كتم المايك الفيزيائي وحمايته من تسريب أي صوت خارجي.
      * كشف نهاية الملف (EOF) والتحول لضخ الصمت الرقمي، وإيقاف الميزة تلقائياً (`persist.sys.unica.vc.inject = false`).

### د) إعدادات البناء والسيرفرات (CI):
11. **`.github/workflows/ci.yml`**:
    * إضافة فرع `sixteen-mic-inject` لقائمة فروع البناء التلقائي لإنتاج ملف الروم عبر GitHub Actions.

---

## 4. دليل الاستخدام العملي (User Guide)

1. **تجهيز الصوت:** من موقع ElevenLabs، أو تليجرام، أو مدير الملفات، اختر أي ملف صوتي.
2. **المشاركة:** اضغط **Share (مشاركة)** ⬅️ اختر **`حقن في الريكورد 💉`**.
3. **تأكيد الجاهزية:** سيظهر لك إشعار سريع أسفل الشاشة: `💉 تم تجهيز الصوت للحقن! سجل ريكورد الآن`.
4. **التسجيل في واتساب:**
   * افتح أي محادثة في واتساب (أو أي تطبيق شات).
   * اضغط مطولاً على زرار المايك للتسجيل.
   * **ستسمع الصوت بنفسك من سبيكر الموبايل** وهو يسجل.
5. **الانتهاء:**
   * بمجرد انتهاء جملة الصوت، سيسكت السبيكر.
   * ارفع إصبعك من على الشاشة، وسيُرسل الريكورد بصوت الذكاء الاصطناعي وبصورة تسجيل طبيعي 100%!
   * بعد الانتهاء، يعود المايك لحالته العادية تلقائياً دون الحاجة لأي تدخل منك.

---

## 5. دليل فحص الأخطاء (Troubleshooting & Debugging)

للتحقق من حالة الميزة عبر ADB:

* **فحص حالة الميزة:**
  ```bash
  adb shell getprop persist.sys.unica.vc.inject
  # ترجع "true" عند تفعيل الحقن، و "false" في الحالة الطبيعية
  ```

* **فحص وجود ملف الصوت الجاهز للحقن:**
  ```bash
  adb shell ls -l /sdcard/Recordings/unica_inject.wav
  ```

* **متابعة سجلات محرك الصوت أثناء التسجيل:**
  ```bash
  adb logcat | grep -iE 'AudioInject|VoiceChanger|AudioDecoder'
  ```
