import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/data/quiz/quiz_controller.dart';
import 'quiz_screen.dart';

class QuizDetailsScreen extends StatelessWidget {
  final String skillName;
  QuizDetailsScreen({super.key, required this.skillName});

  final QuizController controller = Get.put(QuizController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          onPressed: () => Get.back(),
        ),
        title:  Text(
          "Quiz Details",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skillName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Chip(
                        label: Text(
                          "Beginner",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyMedium!.color,

                          ),
                        ),
                        backgroundColor: Color(0XFFF2F5F8),
                      ),
                      SizedBox(width: 8),
                      Chip(
                        label: Text(
                          "15 Q",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        backgroundColor: Color(0XFFF2F5F8),
                      ),
                      SizedBox(width: 8),
                      Chip(
                        label: Text(
                          "15m",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        backgroundColor: Color(0XFFF2F5F8),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Test your knowledge of basics including variables, "
                        "functions and control structures.",
                    style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),

                  const SizedBox(height: 20),
                  rowDetails(context, "Questions:", "15"),
                  SizedBox(height: 8),
                  rowDetails(context, "Time Limit:", "15 minutes"),
                  SizedBox(height: 8),
                  rowDetails(context, "Passing Score:", "85%"),
                  SizedBox(height: 8),
                  rowDetails(context, "Difficulty:", "Beginner"),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Important Notes:",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "• You cannot pause once started",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "• Questions are randomly selected",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "• You need 80% to pass and get verified",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "• You can retake if you don't pass",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Obx(
                  () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF0D035F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed:
                  controller.loading.value
                      ? null
                      : () async {
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
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Start Quiz",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rowDetails(
      BuildContext context,
      String title,
      String subTitle
      ) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:  [
          //"Time Limit:"
          Text( title,
               style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyMedium!.color
          )),
          //"15 minutes"
          Text(subTitle, style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyMedium!.color
          )),
        ],
      );
  }
}