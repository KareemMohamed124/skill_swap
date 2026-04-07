import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../shared/common_ui/screen_manager/screen_manager.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/quiz/quiz_controller.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final int score;
  late final int total;
  late final String skillName;
  late final QuizController controller;

  @override
  void initState() {
    super.initState();

    score = Get.arguments['score'];
    total = Get.arguments['total'];
    skillName = Get.arguments['skill'] ?? '';

    controller = Get.find<QuizController>();

    controller.isSkillVerified.value = false;
    controller.verifiedQuizScore.value = 0;
    controller.verifyError.value = '';

    if (skillName.isNotEmpty) {
      controller.verifySkillQuiz(
        skillName: skillName,
        score: score,
        total: total,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Center(
          child: Obx(() {
            if (controller.isVerifying.value) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppPalette.primary,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Verifying your skill...",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }

            final int displayScore = controller.verifiedQuizScore.value;
            final bool verified =
                controller.isSkillVerified.value && displayScore >= 85;

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    verified ? Icons.emoji_events : Icons.adjust,
                    color: verified ? Colors.amber : Colors.orange,
                    size: screenWidth * 0.15,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    verified ? "Congratulations!" : "Keep Learning!",
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "$displayScore%",
                    style: TextStyle(
                      fontSize: screenWidth * 0.12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "You got $score out of $total questions correct",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: isDark
                          ? AppPalette.darkTextPrimary
                          : AppPalette.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: displayScore / 100,
                      minHeight: screenHeight * 0.015,
                      backgroundColor: const Color(0XFFF2F5F8),
                      valueColor: const AlwaysStoppedAnimation(
                        AppPalette.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.03,
                    ),
                    decoration: BoxDecoration(
                      color:
                          verified ? Colors.green.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          verified ? Icons.check_circle : Icons.cancel,
                          color: verified ? Colors.green : Colors.red,
                        ),
                        SizedBox(width: screenWidth * 0.015),
                        Text(
                          verified ? "Skill Verified" : "Skill Not Verified",
                          style: TextStyle(
                            color: verified ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!verified)
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.01),
                      child: const Text(
                        "Need 85% to pass. Try again!",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.04),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.primary,
                      minimumSize: Size(double.infinity, screenHeight * 0.07),
                      padding: const EdgeInsets.all(14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (verified) {
                        context.read<MyProfileCubit>().refreshProfile();
                      }

                      // حذف QuizController
                      if (Get.isRegistered<QuizController>()) {
                        Get.delete<QuizController>();
                      }

                      Get.to(() => ScreenManager(
                            initialIndex: 4,
                            initialProfileTab: 1,
                          ));
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
