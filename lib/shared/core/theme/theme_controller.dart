import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
<<<<<<< HEAD
=======
import 'theme_helper.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

class ThemeController extends GetxController {
  final _box = GetStorage();

  ThemeMode themeMode = ThemeMode.system;

<<<<<<< HEAD
  @override
  void onInit() {
    super.onInit();
    loadSavedTheme();
  }

  void changeTheme(ThemeMode mode) {
    themeMode = mode;
    _box.write('theme', mode.name);
=======
  void changeTheme(ThemeMode mode) {
    themeMode = mode;

    _box.write('theme', saveThemeToString(mode));

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    update();
  }

  void loadSavedTheme() {
<<<<<<< HEAD
    final savedTheme = _box.read('theme');

    if (savedTheme != null) {
      themeMode = ThemeMode.values.firstWhere(
        (e) => e.name == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
  }

  bool isDarkMode(BuildContext context) {
    if (themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return themeMode == ThemeMode.dark;
  }
}
=======
    final savedTheme = _box.read<String>('theme');

    themeMode = loadThemeFromString(savedTheme);

    update();
  }
}
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
