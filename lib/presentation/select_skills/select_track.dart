import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/core/theme/app_palette.dart';
import 'package:skill_swap/presentation/select_skills/select_skills.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              "Select your Track",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge!.color
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Choose the skills you already have. This will help us connect you with the right mentors and users.",
              style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium!.color
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 12,
                  children:
                      tracks.map((track) {
                        bool isSelected = selectedTrack == track;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTrack = track;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? AppPalette.primary
                                      : Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? AppPalette.primary
                                        : Theme.of(context).dividerColor,
                              ),
                            ),
                            child: Text(
                              track,
                              style: TextStyle(
                                color: isSelected ? Colors.white :
                                (isDark ? AppPalette.darkTextPrimary : AppPalette.lightTextPrimary),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed:
                    selectedTrack != null
                        ? () {
                          Get.to(SelectSkills(selectedTrack: selectedTrack,));
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.primary,
                  minimumSize: const Size(200, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
