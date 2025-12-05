import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:skill_swap/presentation/book_session/screens/book_session.dart';
import 'package:skill_swap/presentation/home/screens/home_screen.dart';
import 'package:skill_swap/presentation/onboarding_screen/screens/onboarding.dart';
import 'package:skill_swap/presentation/profile/screens/profile_screen.dart';
import 'package:skill_swap/presentation/search/screens/search_screen.dart';
import 'package:skill_swap/presentation/sessions/screens/sessions_screen.dart';
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

  await initDependencies();
  runApp(const MyApp());
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
      useInheritedMediaQuery: true,
      /////////////////////////OnBoardingScreen
      home: OnBoardingScreen(),

    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SkillSwap'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Text('Welcome to SkillSwap!', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}