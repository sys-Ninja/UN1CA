-keepattributes *Annotation*
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-dontwarn androidx.**
-dontwarn com.google.mlkit.**
-keep class com.google.mlkit.** { *; }
-keep class io.mesalabs.unica.screentranslator.** { *; }