import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_states.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'theme_mode';

  ThemeCubit() : super(const ThemeInitial()) {
    _loadTheme();
  }

  ThemeMode get currentThemeMode => state.themeMode;

  bool get isDarkMode => state.themeMode == ThemeMode.dark;

  bool get isLightMode => state.themeMode == ThemeMode.light;

  // Cubit provide an instance of ThemeState in itself which holds the current (state) theme mode
  /// Load the saved theme from SharedPreferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeIndex = prefs.getInt(_themeKey);
      // check if savedThemeIndex is not null and then get the ThemeMode
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
        emit(const ThemeInitial());
      }
    } catch (e) {
      log('Error while loading theme: $e');
      emit(const ThemeInitial());
    }
  }

  Future<void> _saveTheme(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, themeMode.index);
    } catch (e) {
      log('Error while saving theme: $e');
    }
  }

  Future<void> toggleTheme() async {
    if (state.themeMode == ThemeMode.light) {
      emit(const ThemeDark());
      await _saveTheme(ThemeMode.dark);
    } else {
      emit(const ThemeLight());
      await _saveTheme(ThemeMode.light);
    }
  }
}


/*
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
*/