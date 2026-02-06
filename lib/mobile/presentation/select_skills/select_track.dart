import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/select_skills/select_skills.dart';

import '../../../shared/core/theme/app_palette.dart';

class SelectTrack extends StatefulWidget {
  const SelectTrack({super.key});

  @override
  State<SelectTrack> createState() => _SelectTrackState();
}

class _SelectTrackState extends State<SelectTrack> {
  List<String> tracks = [
    "Mobile Development",
    "UI/UX Design",
    "Backend Development",
    "DevOps",
    "Artificial Intelligence",
    "Data Science",
    "Game Development",
    "Data Analysis",
    "Graphic Design",
    "Software Testing",
    "Full Stack Development",
    "Cybersecurity",
    "Machine Learning",
    "Frontend Development",
    "Agile",
    "Cloud Computing",
  ];

  String? selectedTrack;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04), // responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.04),
            Text(
              "Select your Track",
              style: TextStyle(
                fontSize: screenWidth * 0.06, // responsive font size
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              "Choose the skills you already have. This will help us connect you with the right mentors and users.",
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: screenWidth * 0.025,
                  runSpacing: screenHeight * 0.015,
                  children: tracks.map((track) {
                    bool isSelected = selectedTrack == track;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTrack = track;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.015,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppPalette.primary
                              : Theme.of(context).cardColor,
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.06),
                          border: Border.all(
                            color: isSelected
                                ? AppPalette.primary
                                : Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Text(
                          track,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                    ? AppPalette.darkTextPrimary
                                    : AppPalette.lightTextPrimary),
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Center(
              child: ElevatedButton(
                onPressed: selectedTrack != null
                    ? () {
                        Get.to(SelectSkills(
                          selectedTrack: selectedTrack,
                        ));
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.primary,
                  minimumSize: Size(screenWidth * 0.5, screenHeight * 0.07),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }
}
