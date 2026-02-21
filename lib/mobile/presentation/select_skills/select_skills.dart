import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../shared/core/theme/app_palette.dart';
import '../../../mobile/presentation/sign/screens/sign_in_screen.dart';
import '../../../shared/bloc/complete_profile_bloc/complete_profile_bloc.dart';
import '../../../shared/bloc/complete_profile_bloc/complete_profile_event.dart';
import '../../../shared/bloc/complete_profile_bloc/complete_profile_state.dart';
import '../../../shared/data/models/complete_profile/complete_profile_request.dart';

class SelectSkillsScreen extends StatefulWidget {
  final String trackId;
  final String trackName;
  final List<String> skills;

  const SelectSkillsScreen({
    super.key,
    required this.trackId,
    required this.trackName,
    required this.skills,
  });

  @override
  State<SelectSkillsScreen> createState() => _SelectSkillsScreenState();
}

class _SelectSkillsScreenState extends State<SelectSkillsScreen> {
  List<String> selectedSkills = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => GetIt.instance<CompleteProfileBloc>(),
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
                  Text(
                    "Select your skills",
                    style: TextStyle(
                      fontSize: size.width * 0.065,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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

                                return GestureDetector(
                                  onTap: isLoading
                                      ? null
                                      : () {
                                          setState(() {
                                            if (isSelected) {
                                              selectedSkills.remove(skill);
                                            } else {
                                              selectedSkills.add(skill);
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
                                      skill,
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
                          ),
                  ),

                  /// 🔥 Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.065,
                    child: ElevatedButton(
                      onPressed: (isLoading || selectedSkills.isEmpty)
                          ? null
                          : () {
                              // Convert selected skill strings to SkillItem objects
                              final skillItems = selectedSkills
                                  .map((s) => SkillItem(
                                        skillName: s,
                                        experienceLevel: null,
                                      ))
                                  .toList();

                              context.read<CompleteProfileBloc>().add(
                                    CompleteProfileSubmitted(
                                      track: widget.trackId, // ObjectId
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
                              style: TextStyle(color: Colors.white),
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
