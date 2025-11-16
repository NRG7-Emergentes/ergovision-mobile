# Keep WebSocket classes
-keep class org.java_websocket.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep STOMP client classes
-keep class com.stomp.** { *; }
-keepclassmembers class * {
    @com.stomp.** *;
}

# Keep web socket channel classes
-keep class io.flutter.plugin.common.** { *; }

# Don't warn about missing classes
-dontwarn org.java_websocket.**
-dontwarn com.stomp.**

# Keep all native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Flutter plugin registrant
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

