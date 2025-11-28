import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_states.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'theme_mode';
  
  ThemeCubit() : super(const ThemeInitial()) {
    _loadTheme();
  }

  /// Load the saved theme from SharedPreferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeIndex = prefs.getInt(_themeKey);
      
      if (savedThemeIndex != null) {
        final themeMode = ThemeMode.values[savedThemeIndex];
        switch (themeMode) {
          case ThemeMode.light:
            emit(const ThemeLight());
            break;
          case ThemeMode.dark:
            emit(const ThemeDark());
            break;
          case ThemeMode.system:
            emit(const ThemeInitial());
            break;
        }
      } else {
        // Default to system theme if no preference saved
        emit(const ThemeInitial());
      }
    } catch (e) {
      // If there's an error loading, default to system theme
      emit(const ThemeInitial());
    }
  }

  /// Save the theme to SharedPreferences
  Future<void> _saveTheme(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, themeMode.index);
    } catch (e) {
      // Handle save error silently
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    if (state.themeMode == ThemeMode.light) {
      emit(const ThemeDark());
      await _saveTheme(ThemeMode.dark);
    } else {
      emit(const ThemeLight());
      await _saveTheme(ThemeMode.light);
    }
  }

  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode themeMode) async {
    switch (themeMode) {
      case ThemeMode.light:
        emit(const ThemeLight());
        break;
      case ThemeMode.dark:
        emit(const ThemeDark());
        break;
      case ThemeMode.system:
        emit(const ThemeInitial());
        break;
    }
    await _saveTheme(themeMode);
  }

  /// Get current theme mode
  ThemeMode get currentThemeMode => state.themeMode;
  
  /// Check if current theme is dark
  bool get isDarkMode => state.themeMode == ThemeMode.dark;
  
  /// Check if current theme is light
  bool get isLightMode => state.themeMode == ThemeMode.light;
}