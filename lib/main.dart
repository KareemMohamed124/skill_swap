import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:get/get.dart';
import 'package:skill_swap/presentation/profile/screens/profile_screen.dart';
import 'dependency_injection/injection.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:skill_swap/data/quiz/quiz_controller.dart';
import 'package:skill_swap/presentation/skill_verification/result_screen.dart';

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
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
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
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const ProfileScreen(),
      getPages: [
        GetPage(name: '/result', page: () => ResultScreen()),
        GetPage(name: '/skills', page: () => const ProfileScreen()),
      ],
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