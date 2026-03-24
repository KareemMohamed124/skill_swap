import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/main.dart';

import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/quiz/quiz_controller.dart';

class ResultScreen extends StatelessWidget {
  final int score = Get.arguments['score'];
  final int total = Get.arguments['total'];

  ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final percent = (score / total) * 100;
    final passed = percent >= 85;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                passed ? Icons.emoji_events : Icons.adjust,
                color: passed ? Colors.amber : Colors.orange,
                size: screenWidth * 0.15, // حجم الأيقونة نسبي للشاشة
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                passed ? "Congratulations!" : "Keep Learning!",
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                "${percent.toInt()}%",
                style: TextStyle(
                  fontSize: screenWidth * 0.12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                "You got $score out of $total questions correct",
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: isDark
                      ? AppPalette.darkTextPrimary
                      : const Color(0xFF0D035F),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.02),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: percent / 100,
                  minHeight: screenHeight * 0.015,
                  backgroundColor: const Color(0XFFF2F5F8),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF0D035F)),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              if (passed)
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.01,
                    horizontal: screenWidth * 0.03,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check,
                          color: Colors.green, size: screenWidth * 0.05),
                      SizedBox(width: screenWidth * 0.015),
                      Text(
                        "Skill Verified",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                        ),
                      ),
                    ],
                  ),
                ),
              if (!passed)
                Text(
                  "Need 85% to pass. Try again!",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.045,
                  ),
                ),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D035F),
                  minimumSize:
                      Size(double.infinity, screenHeight * 0.07), // ارتفاع نسبي
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (Get.isRegistered<QuizController>()) {
                    Get.find<QuizController>().resetQuiz();
                  }
                  desktopKey.currentState?.openPage(index: 4);
                },
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: screenWidth * 0.045, // حجم الخط نسبي
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
