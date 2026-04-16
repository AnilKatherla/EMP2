import 'package:flutter/material.dart';

/// ThemeController — Manages light/dark/system theme switching.
///
/// Uses [ValueNotifier] so the app rebuilds only the root MaterialApp.
/// No external state management needed.
///
/// Usage:
///   final ThemeController themeController = ThemeController();
///
///   // Wrap MaterialApp:
///   `ValueListenableBuilder<ThemeMode>(`
///     valueListenable: themeController,
///     builder: (_, mode, __) => MaterialApp(
///       themeMode: mode,
///       ...
///     ),
///   );
///
///   // Toggle from anywhere:
///   themeController.toggleTheme();
///   themeController.setThemeMode(ThemeMode.dark);
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController([super.value = ThemeMode.system]);

  ThemeMode get themeMode => value;

  bool get isDark => value == ThemeMode.dark;
  bool get isLight => value == ThemeMode.light;
  bool get isSystem => value == ThemeMode.system;

  void setThemeMode(ThemeMode mode) {
    if (value == mode) return;
    value = mode;
    // Optional: persist to shared_preferences
    // _prefs?.setString('themeMode', mode.name);
  }

  void toggleTheme() {
    value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  void useSystemTheme() => setThemeMode(ThemeMode.system);
  void useLightTheme()  => setThemeMode(ThemeMode.light);
  void useDarkTheme()   => setThemeMode(ThemeMode.dark);

  /// Returns effective brightness based on system setting.
  Brightness effectiveBrightness(BuildContext context) {
    if (value == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context);
    }
    return value == ThemeMode.dark ? Brightness.dark : Brightness.light;
  }
}