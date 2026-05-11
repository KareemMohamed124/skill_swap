import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../shared/core/theme/app_palette.dart';
import '../../../mobile/presentation/sign/screens/sign_in_screen.dart';
import '../../../shared/bloc/complete_profile_bloc/complete_profile_bloc.dart';
import '../../../shared/bloc/complete_profile_bloc/complete_profile_event.dart';
import '../../../shared/bloc/complete_profile_bloc/complete_profile_state.dart';
<<<<<<< HEAD
import '../../../shared/bloc/track_cubit/skills_cubit.dart';
import '../../../shared/bloc/track_cubit/skills_state.dart';
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import '../../../shared/data/models/complete_profile/complete_profile_request.dart';

class SelectSkillsScreen extends StatefulWidget {
  final String trackId;
  final String trackName;
<<<<<<< HEAD
=======
  final List<String> skills;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  const SelectSkillsScreen({
    super.key,
    required this.trackId,
    required this.trackName,
<<<<<<< HEAD
=======
    required this.skills,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  });

  @override
  State<SelectSkillsScreen> createState() => _SelectSkillsScreenState();
}

class _SelectSkillsScreenState extends State<SelectSkillsScreen> {
  List<String> selectedSkills = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
<<<<<<< HEAD

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.instance<CompleteProfileBloc>(),
        ),
      ],
=======
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => GetIt.instance<CompleteProfileBloc>(),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      child: BlocConsumer<CompleteProfileBloc, CompleteProfileState>(
        listener: (context, state) {
          if (state is CompleteProfileSuccess) {
            Get.offAll(() => SignInScreen());
          } else if (state is CompleteProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is CompleteProfileLoading;

          return Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.02),
<<<<<<< HEAD

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                  Text(
                    "Select your skills",
                    style: TextStyle(
                      fontSize: size.width * 0.065,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
<<<<<<< HEAD

                  SizedBox(height: size.height * 0.01),

                  Text(
                    "Track: ${widget.trackName}",
                    style: TextStyle(
                      fontSize: size.width * 0.04,
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  /// 🔥 Skills From API
                  Expanded(
                    child: BlocBuilder<SkillsCubit, SkillsState>(
                      builder: (context, skillsState) {
                        if (skillsState is SkillsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (skillsState is SkillsError) {
                          return Center(
                            child: Text(
                              skillsState.error,
                            ),
                          );
                        }

                        if (skillsState is SkillsLoaded) {
                          final skills = skillsState.response.data;

                          if (skills.isEmpty) {
                            return const Center(
                              child: Text(
                                "No skills available",
                              ),
                            );
                          }

                          return SingleChildScrollView(
                            child: Wrap(
                              spacing: size.width * 0.02,
                              runSpacing: size.height * 0.015,
                              children: skills.map((skill) {
                                final isSelected = selectedSkills.contains(
                                  skill.name,
                                );
=======
                  SizedBox(height: size.height * 0.01),
                  Text(
                    "Track: ${widget.trackName}",
                    style: TextStyle(fontSize: size.width * 0.04),
                  ),
                  SizedBox(height: size.height * 0.03),

                  /// 🔥 Skills Chips
                  Expanded(
                    child: widget.skills.isEmpty
                        ? const Center(
                            child: Text("No skills available for this track."),
                          )
                        : SingleChildScrollView(
                            child: Wrap(
                              spacing: size.width * 0.02,
                              runSpacing: size.height * 0.015,
                              children: widget.skills.map((skill) {
                                final isSelected =
                                    selectedSkills.contains(skill);
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

                                return GestureDetector(
                                  onTap: isLoading
                                      ? null
                                      : () {
                                          setState(() {
                                            if (isSelected) {
<<<<<<< HEAD
                                              selectedSkills.remove(
                                                skill.name,
                                              );
                                            } else {
                                              selectedSkills.add(
                                                skill.name,
                                              );
=======
                                              selectedSkills.remove(skill);
                                            } else {
                                              selectedSkills.add(skill);
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                                            }
                                          });
                                        },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.04,
                                      vertical: size.height * 0.012,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppPalette.primary
                                          : Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppPalette.primary
                                            : Theme.of(context).dividerColor,
                                      ),
                                    ),
                                    child: Text(
<<<<<<< HEAD
                                      skill.name,
=======
                                      skill,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                                      style: TextStyle(
                                        fontSize: size.width * 0.035,
                                        color: isSelected
                                            ? Colors.white
                                            : (isDark
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
<<<<<<< HEAD
                          );
                        }

                        return const SizedBox();
                      },
                    ),
=======
                          ),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                  ),

                  /// 🔥 Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.065,
                    child: ElevatedButton(
                      onPressed: (isLoading || selectedSkills.isEmpty)
                          ? null
                          : () {
<<<<<<< HEAD
                              final Set<String> uniqueSkills = {};

                              for (var skill in selectedSkills) {
                                final parts = skill.split('&');

                                for (var part in parts) {
                                  final trimmed = part.trim();

                                  if (trimmed.isNotEmpty) {
                                    uniqueSkills.add(
                                      trimmed,
                                    );
                                  }
                                }
                              }

                              final skillItems = uniqueSkills
                                  .map(
                                    (s) => SkillItem(
                                      skillName: s,
                                      experienceLevel: null,
                                    ),
                                  )
=======
                              // Convert selected skill strings to SkillItem objects
                              final skillItems = selectedSkills
                                  .map((s) => SkillItem(
                                        skillName: s,
                                        experienceLevel: null,
                                      ))
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                                  .toList();

                              context.read<CompleteProfileBloc>().add(
                                    CompleteProfileSubmitted(
<<<<<<< HEAD
                                      track: widget.trackId,
=======
                                      track: widget.trackId, // ObjectId
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                                      skills: skillItems,
                                    ),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              "Continue",
<<<<<<< HEAD
                              style: TextStyle(
                                color: Colors.white,
                              ),
=======
                              style: TextStyle(color: Colors.white),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
