import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/data/quiz/quiz_controller.dart';

class QuizScreen extends StatelessWidget {
  final QuizController controller = Get.find<QuizController>();

  QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      if (controller.questions.isEmpty) {
        return Scaffold(
          body: Center(child: Text("Failed to load quiz. Please try again.")),
        );
      }

      final q = controller.questions[controller.index.value];

      return Scaffold(
        appBar: AppBar(
          title: Text(controller.currentSkill.value),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer),
                  const SizedBox(width: 6),
                  const Text("30:00"),
                  const Spacer(),
                  Text(
                    "${controller.index.value + 1} of ${controller.questions.length}",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value:
                    (controller.index.value + 1) / controller.questions.length,
                backgroundColor: const Color(0XFFD0D2FF),
                color: const Color(0XFF0D035F),
              ),
              const SizedBox(height: 20),
              Text(
                q.question,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(q.options.length, (i) {
                return GestureDetector(
                  onTap: () => controller.selectedOption.value = i,
                  child: Obx(
                    () => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              controller.selectedOption.value == i
                                  ? const Color(0XFF0D035F)
                                  : Colors.grey.shade300,
                          width: controller.selectedOption.value == i ? 2 : 1,
                        ),
                      ),
                      child: Text(q.options[i]),
                    ),
                  ),
                );
              }),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (controller.index.value > 0)
                    OutlinedButton(
                      onPressed: controller.previousQuestion,
                      child: const Text("Previous"),
                    ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF0D035F),
                    ),
                    onPressed: controller.nextQuestion,
                    child: Text(
                      controller.index.value == controller.questions.length - 1
                          ? "Finish"
                          : "Next",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    });
  }
}
