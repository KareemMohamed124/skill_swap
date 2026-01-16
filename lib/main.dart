import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:skill_swap/helper/local_storage.dart';
import 'package:skill_swap/presentation/book_session/screens/book_session.dart';
import 'package:skill_swap/presentation/home/screens/home_screen.dart';
import 'package:skill_swap/presentation/onboarding_screen/screens/onboarding.dart';
import 'package:skill_swap/presentation/profile/screens/profile_screen.dart';
import 'package:skill_swap/presentation/search/screens/search_screen.dart';
import 'package:skill_swap/presentation/select_skills/select_skills.dart';
import 'package:skill_swap/presentation/sessions/screens/sessions_screen.dart';
import 'package:skill_swap/presentation/setting/widgets/profile.dart';
import 'package:skill_swap/presentation/setting/screens/setting.dart';
import 'package:skill_swap/presentation/sign/screens/sign_in_screen.dart';
import 'package:skill_swap/presentation/skill_verification/result_screen.dart';
import 'common_ui/screen_manager/screen_manager.dart';
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

  // 🔹 افتح الـ box هنا قبل أي استدعاء لـ LocalStorage
  await Hive.openBox('appBox');

  await initDependencies();

  // جلب حالة Onboarding و Login بعد ما box مفتوح
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

  runApp(MyApp(startScreen: startScreen));
}

class MyApp extends StatelessWidget {
  final Widget startScreen;
  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SkillSwap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: startScreen, // مباشرة تعرض الصفحة المناسبة
    );
  }
}