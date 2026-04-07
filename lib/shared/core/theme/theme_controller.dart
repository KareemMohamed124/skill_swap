import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'theme_helper.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();

  ThemeMode themeMode = ThemeMode.system;

  void changeTheme(ThemeMode mode) {
    themeMode = mode;

    _box.write('theme', saveThemeToString(mode));

    update();
  }

  void loadSavedTheme() {
    final savedTheme = _box.read<String>('theme');

    themeMode = loadThemeFromString(savedTheme);

    update();
  }
}