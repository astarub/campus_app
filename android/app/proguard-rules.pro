############################################
# Flutter + Dart
############################################
# Keep Flutter engine classes
-keep class io.flutter.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-dontwarn io.flutter.**

############################################
# Firebase
############################################
# Keep Firebase core classes
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Keep Google Play Services (needed for Firebase)
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

############################################
# AndroidX / Jetpack (used by Flutter plugins)
############################################
-keep class androidx.lifecycle.** { *; }
-dontwarn androidx.lifecycle.**

############################################
# Gson / JSON serialization (used by Firebase + plugins)
############################################
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

############################################
# Kotlin coroutines (used by many plugins)
############################################
-keep class kotlinx.coroutines.** { *; }
-dontwarn kotlinx.coroutines.**

############################################
# Prevent stripping of any classes loaded via reflection
############################################
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

############################################
# Miscellaneous
############################################
# Keep constructors
-keepclassmembers class * {
    public <init>(...);
}

# Keep enums
-keepclassmembers enum * {
    **[] $VALUES;
    public *;
}
