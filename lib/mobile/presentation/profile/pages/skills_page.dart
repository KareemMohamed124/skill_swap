import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../skill_verification/quiz_details_screen.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          skillCard(context: context, title: "JavaScript", proficiency: 0.95, verified: true),
          const SizedBox(height: 20),
          skillCard(context: context, title: "React", proficiency: 0.80, verified: false),
          const SizedBox(height: 20),
          skillCard(context: context, title: "Flutter", proficiency: 0.70, verified: false),
        ],
      ),
    );
  }

  Widget skillCard({
    required BuildContext context,
    required String title,
    required double proficiency,
    required bool verified,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  if (verified)
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 18,
                      ),
                    ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: verified ? Colors.green.shade50 : Colors.red.shade50,
                ),
                child: Text(
                  verified ? "Verified" : "Not Verified",
                  style: TextStyle(
                    color: verified ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text("Proficiency", style: TextStyle( color: Theme.of(context).textTheme.bodyMedium!.color,),),
              Text(
                "${(proficiency * 100).round()}%",
                style: TextStyle(fontWeight: FontWeight.bold,  color: Theme.of(context).textTheme.bodyMedium!.color,),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 10,
            child: LinearProgressIndicator(
              value: proficiency,
              color: const Color(0XFF0D035F),
              backgroundColor: const Color(0XFFF2F5F8),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),
          if (!verified)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0XFFF2F5F8),
                  padding: const EdgeInsets.all(14),
                  side: const BorderSide(color: Color(0xFF1B1464), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Get.to(() => QuizDetailsScreen(skillName: title));
                },
                child: const Text(
                  "Take Assessment",
                  style: TextStyle(
                    color: Color(0XFF0D035F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}