import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/select_skills/select_skills.dart';

class SelectTrackScreen extends StatefulWidget {
  const SelectTrackScreen({super.key});

  @override
  State<SelectTrackScreen> createState() => _SelectTrackScreenState();
}

class _SelectTrackScreenState extends State<SelectTrackScreen> {
  String? selectedTrack;

  final Map<String, List<String>> tracksWithSkills = {
    "Mobile Development": [
      "Flutter",
      "Dart",
      "Firebase",
      "REST API",
      "State Management",
      "UI Responsive",
    ],
    "Frontend Development": [
      "HTML",
      "CSS",
      "JavaScript",
      "React",
      "Responsive Design",
      "Animations",
    ],
    "Backend Development": [
      "NodeJS",
      "Laravel",
      "Django",
      "SQL",
      "Authentication",
      "API Design",
    ],
    "UI/UX Design": [
      "Figma",
      "Wireframing",
      "Prototyping",
      "User Research",
      "Design System",
    ],
    "Artificial Intelligence": [
      "Python",
      "TensorFlow",
      "Deep Learning",
      "NLP",
      "Computer Vision",
    ],
    "Data Science": [
      "Pandas",
      "NumPy",
      "Data Cleaning",
      "Visualization",
      "Statistics",
    ],
    "Game Development": [
      "Unity",
      "C#",
      "Level Design",
      "3D Design",
      "Physics Simulation",
      "Animation",
    ],
    "Cybersecurity": [
      "Networking",
      "Linux",
      "Penetration Testing",
      "Cryptography",
      "OWASP",
    ],
    "Cloud Computing": [
      "Docker",
      "CI/CD",
      "Kubernetes",
      "Monitoring",
      "Linux Server",
    ],
    "Software Testing": [
      "Unit Testing",
      "Automation",
      "Manual Testing",
      "Test Cases",
      "Bug Tracking",
    ],
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              "Select your Track",
              style: TextStyle(
                fontSize: size.width * 0.065,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              "Choose the skills you already have. This will help us connect you with the right mentors and users.",
              style: TextStyle(fontSize: size.width * 0.035),
            ),
            SizedBox(height: size.height * 0.03),

            /// 🔥 Tracks Chips
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: size.width * 0.02,
                  runSpacing: size.height * 0.015,
                  children: tracksWithSkills.keys.map((track) {
                    final isSelected = selectedTrack == track;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTrack = track;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: size.height * 0.012,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xff0D0B5C)
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xff0D0B5C)
                                : Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Text(
                          track,
                          style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.02),

            /// 🔥 Continue Button
            Center(
              child: SizedBox(
                width: size.width * 0.6,
                height: size.height * 0.065,
                child: ElevatedButton(
                  onPressed: selectedTrack == null
                      ? null
                      : () {
                          Get.to(
                            SelectSkillsScreen(
                              trackName: selectedTrack!,
                              skills: tracksWithSkills[selectedTrack!]!,
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0D0B5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
