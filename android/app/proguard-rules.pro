# Google ML Kit Text Recognition
-dontwarn com.google.mlkit.vision.text.chinese.ChineseTextRecognizerOptions
-dontwarn com.google.mlkit.vision.text.chinese.ChineseTextRecognizerOptions$Builder
-dontwarn com.google.mlkit.vision.text.devanagari.DevanagariTextRecognizerOptions
-dontwarn com.google.mlkit.vision.text.devanagari.DevanagariTextRecognizerOptions$Builder
-dontwarn com.google.mlkit.vision.text.japanese.JapaneseTextRecognizerOptions
-dontwarn com.google.mlkit.vision.text.japanese.JapaneseTextRecognizerOptions$Builder
-dontwarn com.google.mlkit.vision.text.korean.KoreanTextRecognizerOptions
-dontwarn com.google.mlkit.vision.text.korean.KoreanTextRecognizerOptions$Builder

# Facebook Ads SDK - Complete Rules
-keep class com.facebook.** { *; }
-keep interface com.facebook.** { *; }
-dontwarn com.facebook.**

# Facebook Infer Annotations (Missing classes fix)
-dontwarn com.facebook.infer.annotation.Nullsafe
-dontwarn com.facebook.infer.annotation.Nullsafe$Mode
-dontwarn com.facebook.infer.annotation.**

# Keep all Facebook Ads classes
-keep class com.facebook.ads.** { *; }
-keepclassmembers class com.facebook.ads.** { *; }

# Facebook Audience Network - Specific Classes
-keep class com.facebook.ads.internal.** { *; }
-keep class com.facebook.ads.AbstractAdListener { *; }
-keep class com.facebook.ads.Ad { *; }
-keep class com.facebook.ads.AdError { *; }
-keep class com.facebook.ads.AdListener { *; }
-keep class com.facebook.ads.AdSettings { *; }
-keep class com.facebook.ads.AdSize { *; }
-keep class com.facebook.ads.AdView { *; }
-keep class com.facebook.ads.AudienceNetworkAds { *; }
-keep class com.facebook.ads.InterstitialAd { *; }
-keep class com.facebook.ads.NativeAd { *; }

# Keep annotations and signatures
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses


# Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Gson (for JSON parsing)
-keepattributes Signature
-keepattributes *Annotation*
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.** { *; }

# Keep all model classes (if using Gson/JSON)
-keep class * extends java.io.Serializable { *; }

# General optimizations
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose
