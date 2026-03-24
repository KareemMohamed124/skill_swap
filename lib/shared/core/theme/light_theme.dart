import 'package:flutter/material.dart';
import 'app_palette.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,

  scaffoldBackgroundColor: AppPalette.lightBackground,
  primaryColor: AppPalette.lightPrimary,

  cardColor: AppPalette.lightCard,
  dividerColor: AppPalette.lightBorder,

  appBarTheme: const AppBarTheme(
    backgroundColor: AppPalette.lightBackground,
    foregroundColor: AppPalette.lightTextPrimary,
    elevation: 0,
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: AppPalette.lightTextPrimary,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: AppPalette.lightTextSecondary,
      fontSize: 14,
        fontWeight: FontWeight.w500
    ),
    bodySmall: TextStyle(
      color: AppPalette.lightTextPrimary,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: AppPalette.lightTextSecondary,
      fontSize: 10,
    ),
    titleMedium: TextStyle(
      color: AppPalette.lightTextPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppPalette.lightSurface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppPalette.lightBorder,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppPalette.lightBorder,
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