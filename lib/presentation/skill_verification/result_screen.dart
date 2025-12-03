import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/data/quiz/quiz_controller.dart';

class ResultScreen extends StatelessWidget {
  final int score = Get.arguments['score'];
  final int total = Get.arguments['total'];

  ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final percent = (score / total) * 100;
    final passed = percent >= 85;

    return Scaffold(
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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${percent.toInt()}%",
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("You got $score out of $total"),
              const SizedBox(height: 30),
              if (passed)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "✔ Skill Verified",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              if (!passed)
                const Text(
                  "Need 85% to pass. Try again!",
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF0D035F),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Get.find<QuizController>().resetQuiz();
                  Get.offAllNamed('/skills');
                },
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
