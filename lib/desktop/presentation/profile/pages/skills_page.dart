import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< HEAD
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/core/theme/app_palette.dart';
=======
import 'package:skill_swap/main.dart';

import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import '../../skill_verification/quiz_details_screen.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, state) {
<<<<<<< HEAD
        /// ───────── Loading ─────────
        if (state is MyProfileLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        /// ───────── Error ─────────
=======
        if (state is MyProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        if (state is MyProfileError) {
          return Center(child: Text(state.message));
        }

<<<<<<< HEAD
        /// ───────── Success ─────────
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        if (state is MyProfileLoaded) {
          final skills = state.profile.skills;

          if (skills.isEmpty) {
<<<<<<< HEAD
            return const Center(
              child: Text("No skills found"),
            );
          }

          return RefreshIndicator(
            /// 🔥 Pull to refresh (اختياري بس ممتاز)
            onRefresh: () async {
              context.read<MyProfileCubit>().refreshProfile();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: skills.length,
              itemBuilder: (context, index) {
                final skill = skills[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SkillCard(
=======
            return const Center(child: Text("No skills found"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: skills.map((skill) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: skillCard(
                    context: context,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                    title: skill.skillName,
                    proficiency: (skill.quizScore / 100).clamp(0.0, 1.0),
                    verified: skill.isVerified,
                  ),
                );
<<<<<<< HEAD
              },
=======
              }).toList(),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            ),
          );
        }

<<<<<<< HEAD
        /// Initial
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        return const SizedBox();
      },
    );
  }
<<<<<<< HEAD
}

///
/// ================= Skill Card =================
///
class SkillCard extends StatelessWidget {
  final String title;
  final double proficiency;
  final bool verified;

  const SkillCard({
    super.key,
    required this.title,
    required this.proficiency,
    required this.verified,
  });

  @override
  Widget build(BuildContext context) {
=======

  Widget skillCard({
    required BuildContext context,
    required String title,
    required double proficiency,
    required bool verified,
  }) {
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
<<<<<<< HEAD
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
=======
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
<<<<<<< HEAD
          /// ───── Title + Status ─────
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title,
<<<<<<< HEAD
                    overflow: TextOverflow.ellipsis,
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
<<<<<<< HEAD

                  /// ✅ Verified Icon
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD

              /// Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
=======
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD

          const SizedBox(height: 16),

          /// ───── Proficiency Text ─────
=======
          const SizedBox(height: 16),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Proficiency",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              Text(
                "${(proficiency * 100).round()}%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
            ],
          ),
<<<<<<< HEAD

          const SizedBox(height: 6),

          /// Progress Bar
=======
          const SizedBox(height: 6),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          SizedBox(
            height: 10,
            child: LinearProgressIndicator(
              value: proficiency,
<<<<<<< HEAD
              color: AppPalette.primary,
=======
              color: const Color(0XFF0D035F),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              backgroundColor: const Color(0XFFF2F5F8),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
<<<<<<< HEAD

          const SizedBox(height: 16),

=======
          const SizedBox(height: 16),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          if (!verified)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0XFFF2F5F8),
                  padding: const EdgeInsets.all(14),
<<<<<<< HEAD
                  side: const BorderSide(color: AppPalette.primary, width: 2),
=======
                  side: const BorderSide(color: Color(0xFF1B1464), width: 2),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
<<<<<<< HEAD
                  Get.to(() => QuizDetailsDesktop(skillName: title));
=======
                  desktopKey.currentState?.openSidePage(
                    body: QuizDetailsScreen(skillName: title),
                  );
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                },
                child: const Text(
                  "Take Assessment",
                  style: TextStyle(
<<<<<<< HEAD
                    color: AppPalette.primary,
=======
                    color: Color(0XFF0D035F),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
