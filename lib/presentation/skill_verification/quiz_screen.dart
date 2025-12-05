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
        return const Scaffold(
          body: Center(child: Text("Failed to load quiz. Please try again.")),
        );
      }

      final q = controller.questions[controller.index.value];

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),

        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer, color: Color(0xFF0D035F)),
                  const SizedBox(width: 6),
                  const Text(
                    "30:00",
                    style: TextStyle(
                      color: Color(0xFF0D035F),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFF0D035F)),
                    ),
                    child: Text(
                      "${controller.index.value + 1} of ${controller.questions.length}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF0D035F),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value:
                      (controller.index.value + 1) /
                      controller.questions.length,
                  minHeight: 10,
                  backgroundColor: const Color(0XFFF2F5F8),
                  color: const Color(0xFF0D035F),
                ),
              ),

              const SizedBox(height: 16),
              Text(
                "Question ${controller.index.value + 1} of ${controller.questions.length}",
                style: const TextStyle(color: Color(0xFF0D035F), fontSize: 14),
              ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Color(0xFF0D035F), width: 1.2),
                ),
                child: Text(
                  q.question,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 22),

              ...List.generate(q.options.length, (i) {
                final isSelected = controller.selectedOption.value == i;

                return GestureDetector(
                  onTap: () => controller.selectedOption.value = i,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0XFFF2F5F8) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color:
                            isSelected
                                ? const Color(0xFF0D035F)
                                : Color(0XFFF2F5F8),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (isSelected)
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.circle,
                              size: 10,
                              color: Color(0xFF0D035F),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            q.options[i],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const Spacer(),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFF0D035F)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed:
                          controller.index.value == 0
                              ? null
                              : controller.previousQuestion,
                      child: const Text(
                        "Previous",
                        style: TextStyle(
                          color: Color(0xFF0D035F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D035F),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: controller.nextQuestion,
                      child: Text(
                        controller.index.value ==
                                controller.questions.length - 1
                            ? "Finish"
                            : "Next",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
