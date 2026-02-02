import 'package:flutter/material.dart';
import 'app_palette.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,

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

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppPalette.darkSurface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
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