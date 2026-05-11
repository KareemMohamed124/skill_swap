import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final box = GetStorage();

  Locale get initialLanguage {
    String? langCode = box.read('lang');

    if (langCode != null) {
      return langCode == 'ar'
          ? const Locale('ar', 'EG')
          : const Locale('en', 'US');
    }

    Locale deviceLocale = Get.deviceLocale ?? const Locale('en', 'US');

<<<<<<< HEAD
    return deviceLocale.languageCode == 'ar'
        ? const Locale('ar', 'EG')
        : const Locale('en', 'US');
  }

  String get currentLangCode {
    String? langCode = box.read('lang');

    if (langCode != null) return langCode;

    Locale deviceLocale = Get.deviceLocale ?? const Locale('en', 'US');

    return deviceLocale.languageCode == 'ar' ? 'ar' : 'en';
  }

  void changeLanguage(String langCode) {
    Locale locale =
        langCode == 'ar' ? const Locale('ar', 'EG') : const Locale('en', 'US');

    Get.updateLocale(locale);
    box.write('lang', langCode);
    update();
  }
}
=======
    if (deviceLocale.languageCode == 'ar') {
      return const Locale('ar', 'EG');
    } else {
      return const Locale('en', 'US');
    }
  }
  String get currentLangCode {
    return box.read('lang') ?? 'en';
  }
  void changeLanguage(String langCode) {
    Locale locale =
    langCode == 'ar' ? const Locale('ar', 'EG') : const Locale('en', 'US');

    Get.updateLocale(locale);
    box.write('lang', langCode);
  }
}
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
