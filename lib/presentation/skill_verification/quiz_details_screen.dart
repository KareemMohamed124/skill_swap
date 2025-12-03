import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/data/quiz/quiz_controller.dart';
import 'quiz_screen.dart';

class QuizDetailsScreen extends StatelessWidget {
  final String skillName;
  QuizDetailsScreen({super.key, required this.skillName});

  final QuizController controller = Get.put(QuizController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(skillName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              skillName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Chip(label: Text("Beginner")),
                SizedBox(width: 8),
                Chip(label: Text("10 Q")),
                SizedBox(width: 8),
                Chip(label: Text("30m")),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Test your knowledge of basics. Questions are randomly selected.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F5F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Important Notes:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text("• You cannot pause once started"),
                  Text("• Questions are randomly generated"),
                  Text("• You need 85% to pass"),
                  Text("• You can retake if you don't pass"),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF0D035F),
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed:
                      controller.loading.value
                          ? null
                          : () async {
                            // يبدأ التحميل
                            controller.loading.value = true;

                            await controller.generateQuiz(skillName);

                            controller.loading.value = false;

                            if (controller.questions.isNotEmpty) {
                              Get.to(() => QuizScreen());
                            } else {
                              Get.snackbar(
                                'Error',
                                'Failed to generate quiz.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                  child:
                      controller.loading.value
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text("Start Quiz"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
