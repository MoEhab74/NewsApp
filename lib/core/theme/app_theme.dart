import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryOrange = Colors.orange;
  static const Color primaryBlack = Colors.black;
  static const Color primaryWhite = Colors.white;

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: Colors.orange,
    primaryColor: primaryOrange,
    scaffoldBackgroundColor: Colors.white,
    
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    
    // Card Theme
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    // Drawer Theme
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // List Tile Theme
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.black54,
      textColor: Colors.black87,
    ),
    
    // Text Theme
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: Colors.black87),
      headlineMedium: TextStyle(color: Colors.black87),
      headlineSmall: TextStyle(color: Colors.black87),
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black54),
    ),
    
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryOrange,
      brightness: Brightness.light,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: Colors.orange,
    primaryColor: primaryOrange,
    scaffoldBackgroundColor: const Color(0xFF121212),
    
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    
    // Card Theme
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 4,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    // Drawer Theme
    drawerTheme: DrawerThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // List Tile Theme
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.white70,
      textColor: Color(0xFFE0E0E0),
    ),
    
    // Text Theme
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: Color(0xFFE0E0E0)),
      headlineMedium: TextStyle(color: Color(0xFFE0E0E0)),
      headlineSmall: TextStyle(color: Color(0xFFE0E0E0)),
      bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
      bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
      bodySmall: TextStyle(color: Colors.white70),
    ),
    
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryOrange,
      brightness: Brightness.dark,
    ),
  );
}