import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/quiz/quiz_controller.dart';

class QuizScreen extends StatefulWidget {
  final bool fromAddSkill;

  const QuizScreen({super.key, this.fromAddSkill = false});

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (controller.loading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.questions.isEmpty) {
        return const Scaffold(
          body: Center(child: Text("Failed to load quiz")),
        );
      }

      final q = controller.questions[controller.index.value];

      return Scaffold(
        backgroundColor: AppPalette.primary,
        appBar: AppBar(
          backgroundColor: AppPalette.primary,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "Quiz",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Timer + question count
                    Row(
                      children: [
                        Icon(Icons.timer,
                            color: isDark
                                ? AppPalette.darkTextPrimary
                                : AppPalette.primary),
                        const SizedBox(width: 8),
                        Obx(
                          () => Text(
                            formattedTime,
                            style: TextStyle(
                              color: isDark
                                  ? AppPalette.darkTextPrimary
                                  : AppPalette.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Obx(
                            () => Text(
                              "${controller.index.value + 1} of ${controller.questions.length}",
                              style: TextStyle(
                                color: isDark
                                    ? AppPalette.darkTextPrimary
                                    : AppPalette.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// Progress
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (controller.index.value + 1) /
                            controller.questions.length,
                        minHeight: 8,
                        backgroundColor: const Color(0XFFF2F5F8),
                        color: AppPalette.primary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Question ${controller.index.value + 1} of ${controller.questions.length}",
                      style: TextStyle(
                        color: isDark
                            ? AppPalette.darkTextPrimary
                            : AppPalette.primary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Question Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: Text(
                        q.question,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.6,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Options (Responsive Grid)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 600;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: q.options.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isWide ? 2 : 1,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: isWide ? 3 : 4,
                          ),
                          itemBuilder: (context, i) {
                            final isSelected =
                                controller.selectedOption.value == i;

                            return GestureDetector(
                              onTap: () => controller.selectedOption.value = i,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0XFFF2F5F8)
                                      : Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppPalette.primary
                                        : Theme.of(context).dividerColor,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    q.options[i],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    /// Buttons
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 400,
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: controller.index.value == 0
                                    ? null
                                    : controller.previousQuestion,
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: const Text(
                                  "Previous",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: controller.nextQuestion,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppPalette.primary,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
