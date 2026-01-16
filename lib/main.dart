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
  await initDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SkillSwap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: FutureBuilder(
        future: _getStartScreen(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data!;
        },
      ),
    );
  }

  Future<Widget> _getStartScreen() async {
    final isOnboardingSeen = await LocalStorage.isOnboardingSeen();
    final isLogged = await LocalStorage.isLoggedIn();

    if (!isOnboardingSeen) return OnBoardingScreen();
    if (isLogged) return ScreenManager();
    return const SignInScreen();
  }
}