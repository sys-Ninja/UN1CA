-keepattributes *Annotation*
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-dontwarn androidx.**
-dontwarn com.google.android.libraries.places.**
-keep class com.google.android.libraries.places.** { *; }
-keep class io.mesalabs.unica.prayertimes.** { *; }