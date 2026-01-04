import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/data/quiz/quiz_controller.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizController controller = Get.find<QuizController>();

  RxInt remainingSeconds = QuizController.totalTimeInSeconds.obs;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
        controller.goToResult();
      }
    });
  }

  String get formattedTime {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      if (controller.loading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      if (controller.questions.isEmpty) {
        return const Scaffold(body: Center(child: Text("Failed to load quiz")));
      }

      final q = controller.questions[controller.index.value];

      return Scaffold(
        backgroundColor: const Color(0xFF0D035F),

        appBar: AppBar(
          backgroundColor: const Color(0xFF0D035F),
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "Quiz",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),

        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top,
            ),
            child: Container(
              width: screenWidth,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Timer + question count
                  Row(
                    children: [
                      const Icon(Icons.timer, color: Color(0xFF0D035F)),
                      const SizedBox(width: 8),
                      Obx(
                        () => Text(
                          formattedTime,
                          style: const TextStyle(
                            color: Color(0xFF0D035F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF0D035F)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Obx(
                          () => Text(
                            "${controller.index.value + 1} of ${controller.questions.length}",
                            style: const TextStyle(color: Color(0xFF0D035F)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Progress
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value:
                          (controller.index.value + 1) /
                          controller.questions.length,
                      minHeight: 8,
                      backgroundColor: const Color(0XFFF2F5F8),
                      color: const Color(0xFF0D035F),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "Question ${controller.index.value + 1} of ${controller.questions.length}",
                    style: const TextStyle(color: Color(0xFF0D035F)),
                  ),

                  const SizedBox(height: 16),

                  /// Question
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF0D035F)),
                    ),
                    child: Text(
                      q.question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Options
                  ...List.generate(q.options.length, (i) {
                    final isSelected = controller.selectedOption.value == i;

                    return GestureDetector(
                      onTap: () => controller.selectedOption.value = i,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(0XFFF2F5F8)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color:
                                isSelected
                                    ? const Color(0xFF0D035F)
                                    : const Color(0XFFF2F5F8),
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  /// Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              controller.index.value == 0
                                  ? null
                                  : controller.previousQuestion,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0D035F)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Previous",
                            style: TextStyle(
                              color: Color(0xFF0D035F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controller.nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D035F),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Obx(
                            () => Text(
                              controller.index.value ==
                                      controller.questions.length - 1
                                  ? "Finish"
                                  : "Next",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
