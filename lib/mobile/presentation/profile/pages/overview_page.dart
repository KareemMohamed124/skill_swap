import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/core/theme/app_palette.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double containerWidth = screenWidth < 600 ? screenWidth : 600;

    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, state) {
        if (state is MyProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MyProfileError) {
          return Center(child: Text(state.message));
        }

        if (state is MyProfileLoaded) {
          final profile = state.profile;

          final helpedHours = profile.helpTotalHours ?? 0;
          const requiredHours = 100;
          final helpProgress = (helpedHours / requiredHours).clamp(0.0, 1.0);

          final totalRequiredSkills = profile.skills.length;
          final verifiedSkills =
              profile.skills
                  .where((s) => s.isVerified)
                  .length;

          final verifyProgress =
          (verifiedSkills / totalRequiredSkills).clamp(0.0, 1.0);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: containerWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// =========================
                    /// Progress Container
                    /// =========================
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 6)
                        ],
                        border:
                        Border.all(color: Theme
                            .of(context)
                            .dividerColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.filter_center_focus,
                                color: isDark
                                    ? AppPalette.darkTextPrimary
                                    : AppPalette.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "progress_to_mentor".tr,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          /// Help Others Progress
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  "Help others ($helpedHours/$requiredHours hours)",
                                  style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color,
                                  ),
                                ),
                              ),
                              Text(
                                "${(helpProgress * 100).round()}%",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 10,
                            child: LinearProgressIndicator(
                              value: helpProgress,
                              color: AppPalette.primary,
                              backgroundColor: const Color(0XFFF2F5F8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 16),

                          /// Verify Skills Progress
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  "Verify skills ($verifiedSkills/$totalRequiredSkills required)",
                                  style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color,
                                  ),
                                ),
                              ),
                              Text(
                                "${(verifyProgress * 100).round()}%",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 10,
                            child: LinearProgressIndicator(
                              value: verifyProgress,
                              color: AppPalette.primary,
                              backgroundColor: const Color(0XFFF2F5F8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 20),

                          /// Buttons
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppPalette.primary,
                                padding: const EdgeInsets.all(14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "complete_skills_verification".tr,
                                style: const TextStyle(
                                  color: Color(0XFFF2F5F8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0XFFF2F5F8),
                                padding: const EdgeInsets.all(14),
                                side: const BorderSide(
                                    color: AppPalette.primary, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "apply_mentor".tr,
                                style: const TextStyle(
                                  color: AppPalette.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// =========================
                    /// Recent Activity Container
                    /// =========================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 10)
                        ],
                        border:
                        Border.all(color: Theme
                            .of(context)
                            .dividerColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "recent_activity".tr,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          activityItem(context, "Completed React assessment",
                              "2 days ago"),
                          activityItem(context, "Helped Sarah with JavaScript",
                              "3 days ago"),
                          activityItem(context, "Joined React community chat",
                              "1 week ago"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget activityItem(BuildContext context, String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 10,
            color: Theme
                .of(context)
                .textTheme
                .bodyLarge!
                .color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium!
                    .color,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium!
                  .color,
            ),
          ),
        ],
      ),
    );
  }
}
