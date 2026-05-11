import 'package:flutter/material.dart';
<<<<<<< HEAD

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import 'app_palette.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
<<<<<<< HEAD
  scaffoldBackgroundColor: AppPalette.darkBackground,
  colorScheme: const ColorScheme.dark(
    primary: AppPalette.primary,
    background: AppPalette.darkBackground,
    surface: AppPalette.darkSurface,
    surfaceVariant: AppPalette.darkCard,
    outline: AppPalette.darkBorder,
  ),
  cardColor: AppPalette.darkCard,
  dividerColor: AppPalette.darkBorder,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppPalette.darkBackground,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppPalette.darkTextPrimary),
    bodyMedium: TextStyle(color: AppPalette.darkTextSecondary),
  ),
=======

  scaffoldBackgroundColor: AppPalette.darkBackground,
  primaryColor: AppPalette.darkPrimary,

  cardColor: AppPalette.darkCard,
  dividerColor: AppPalette.darkBorder,

  appBarTheme: const AppBarTheme(
    backgroundColor: AppPalette.darkBackground,
    foregroundColor: AppPalette.darkTextPrimary,
    elevation: 0,
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: AppPalette.darkTextPrimary,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: AppPalette.darkTextSecondary,
      fontSize: 14,
    ),
    bodySmall: TextStyle(
      color: AppPalette.darkTextPrimary,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: AppPalette.darkTextSecondary,
      fontSize: 10,
    ),
    titleMedium: TextStyle(
      color: AppPalette.darkTextPrimary,
      fontWeight: FontWeight.w600,
    ),
  ),

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppPalette.darkSurface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
<<<<<<< HEAD
      borderSide: const BorderSide(color: AppPalette.darkBorder),
    ),
  ),
);
=======
      borderSide: const BorderSide(
        color: AppPalette.darkBorder,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppPalette.darkBorder,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppPalette.primary,
      ),
    ),
  ),
);
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
