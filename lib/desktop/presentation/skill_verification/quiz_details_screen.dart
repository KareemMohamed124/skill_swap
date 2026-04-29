import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/quiz/quiz_controller.dart';
import 'quiz_screen.dart';

class QuizDetailsScreen extends StatelessWidget {
  final String skillName;
  final bool fromAddSkill;

  QuizDetailsScreen(
      {super.key, required this.skillName, this.fromAddSkill = false});

  final QuizController controller = Get.put(QuizController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Quiz Details",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      /// 💻 Desktop Layout
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;

                return Column(
                  children: [
                    _buildDetailsCard(context),
                    const SizedBox(height: 20),
                    _buildNotesCard(context),
                    const SizedBox(height: 20),
                    _buildStartButton(context),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// 📦 Details Card
  Widget _buildDetailsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            skillName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),

          const SizedBox(height: 16),

          /// Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              Chip(label: Text("Beginner")),
              Chip(label: Text("15 Q")),
              Chip(label: Text("15m")),
            ],
          ),

          const SizedBox(height: 16),

          /// Description
          Text(
            "Test your knowledge of basics including variables, "
            "functions and control structures.",
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),

          const SizedBox(height: 20),

          _rowDetails(context, "Questions:", "15"),
          _rowDetails(context, "Time Limit:", "15 minutes"),
          _rowDetails(context, "Passing Score:", "85%"),
          _rowDetails(context, "Difficulty:", "Beginner"),
        ],
      ),
    );
  }

  /// 📌 Notes
  Widget _buildNotesCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Important Notes:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
          const SizedBox(height: 10),
          _note(context, "You cannot pause once started"),
          _note(context, "Questions are randomly selected"),
          _note(context, "You need 80% to pass and get verified"),
          _note(context, "You can retake if you don't pass"),
        ],
      ),
    );
  }

  Widget _note(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        "• $text",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyLarge!.color,
        ),
      ),
    );
  }

  /// ▶️ Start Button (LOGIC SAME)
  Widget _buildStartButton(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPalette.primary,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: controller.loading.value
              ? null
              : () async {
                  controller.loading.value = true;
                  await controller.generateQuiz(skillName,
                      isAddSkill: fromAddSkill);
                  controller.loading.value = false;
                  if (controller.questions.isNotEmpty) {
                    Get.to(() => QuizScreen(fromAddSkill: fromAddSkill));
                  } else {
                    Get.snackbar(
                      'Error',
                      'Failed to generate quiz.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
          child: controller.loading.value
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.timer, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Start Quiz",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _rowDetails(BuildContext context, String title, String subTitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium!.color,
              )),
          Text(subTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              )),
        ],
      ),
    );
  }
}
