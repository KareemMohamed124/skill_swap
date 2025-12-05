import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/data/quiz/quiz_controller.dart';
import 'package:skill_swap/presentation/profile/screens/profile_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score = Get.arguments['score'];
  final int total = Get.arguments['total'];

  ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final percent = (score / total) * 100;
    final passed = percent >= 85;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                passed ? Icons.emoji_events : Icons.adjust,
                color: passed ? Colors.amber : Colors.orange,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                passed ? "Congratulations!" : "Keep Learning!",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${percent.toInt()}%",
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "You got $score out of $total questions correct",
                style: const TextStyle(fontSize: 16, color: Color(0xFF0D035F)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: percent / 100,
                  minHeight: 10,
                  backgroundColor: Color(0XFFF2F5F8),
                  valueColor: AlwaysStoppedAnimation(const Color(0xFF0D035F)),
                ),
              ),
              const SizedBox(height: 20),
              if (passed)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check, color: Colors.green, size: 20),
                      SizedBox(width: 6),
                      Text(
                        "Skill Verified",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              if (!passed)
                const Text(
                  "Need 85% to pass. Try again!",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D035F),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (Get.isRegistered<QuizController>()) {
                    Get.find<QuizController>().resetQuiz();
                  }
                  Get.to(ProfileScreen());
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Color(0xFF0D035F)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "Back to Profile",
                  style: TextStyle(
                    color: Color(0xFF0D035F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}