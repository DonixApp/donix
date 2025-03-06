import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A StateNotifier that manages the theme state (dark/light mode) of the app.
///
/// This notifier persists the theme preference using SharedPreferences.
/// The state is a boolean where:
/// - true = dark mode
/// - false = light mode
class ThemeNotifier extends StateNotifier<bool> {
  static const String _prefsKey = 'isDarkMode';

  /// Creates a new ThemeNotifier with the default theme (light mode).
  ///
  /// Immediately attempts to load the saved theme preference.
  ThemeNotifier() : super(false) {
    _loadThemePreference();
  }

  /// Loads the saved theme preference from SharedPreferences.
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDarkMode = prefs.getBool(_prefsKey) ?? false;

      // Only update state if it's different from current state
      if (isDarkMode != state) {
        state = isDarkMode;
      }
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
      // Fallback to light mode in case of error
      state = false;
    }
  }

  /// Saves the current theme preference to SharedPreferences.
  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKey, state);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  /// Toggles between dark and light mode.
  void toggleTheme() {
    state = !state;
    _saveThemePreference();
  }

  /// Sets the theme mode explicitly.
  ///
  /// @param isDarkMode true for dark mode, false for light mode
  void setTheme(bool isDarkMode) {
    if (state != isDarkMode) {
      state = isDarkMode;
      _saveThemePreference();
    }
  }

  /// Returns the current ThemeMode based on the state.
  ThemeMode get themeMode => state ? ThemeMode.dark : ThemeMode.light;
}

/// A provider for accessing the theme state throughout the app.
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

/// Extension methods for BuildContext to easily access theme-related properties.
extension ThemeExtension on BuildContext {
  /// Returns true if the current theme is dark mode.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Returns the appropriate color based on the current theme.
  Color adaptiveColor(Color lightColor, Color darkColor) {
    return isDarkMode ? darkColor : lightColor;
  }
}

