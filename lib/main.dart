import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:skill_swap/core/localization/app_translation.dart';
import 'package:skill_swap/core/localization/language_controller.dart';
import 'package:skill_swap/core/theme/dark_theme.dart';
import 'package:skill_swap/helper/local_storage.dart';
import 'package:skill_swap/presentation/onboarding_screen/screens/onboarding.dart';
import 'package:skill_swap/presentation/sign/screens/sign_in_screen.dart';
import 'common_ui/screen_manager/screen_manager.dart';
import 'core/theme/light_theme.dart';
import 'core/theme/theme_controller.dart';
import 'data/quiz/quiz_controller.dart';
import 'dependency_injection/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    Gemini.init(apiKey: QuizController.apiKey);
    print("✅ Gemini initialized with API key");
  } catch (e) {
    print("❌ Failed to initialize Gemini: $e");
    print(
      "⚠️ Please check your API key at: https://aistudio.google.com/app/apikey",
    );
  }

  await Hive.initFlutter();

  await Hive.openBox('appBox');

  await initDependencies();

  await GetStorage.init();

  final isOnboardingSeen = await LocalStorage.isOnboardingSeen();
  final isLogged = await LocalStorage.isLoggedIn();

  Widget startScreen;

  if (!isOnboardingSeen) {
    startScreen = OnBoardingScreen();
  } else if (isLogged) {
    startScreen = ScreenManager();
  } else {
    startScreen = const SignInScreen();
  }
  Get.put(ThemeController()..loadSavedTheme());
  runApp(MyApp(startScreen: startScreen));
}

class MyApp extends StatelessWidget {
  final Widget startScreen;
  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    final LanguageController langController = Get.put(LanguageController());
    return GetBuilder<ThemeController>(
      builder: (controller) {
        return  GetMaterialApp(
          title: 'SkillSwap',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: controller.themeMode,
          translations: AppTranslation(),
          locale: langController.initialLanguage,
          fallbackLocale: const Locale("en", "US"),
          home: startScreen,
        );
      },
    );
  }
}