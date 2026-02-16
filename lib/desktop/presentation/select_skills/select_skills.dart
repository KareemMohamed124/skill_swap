import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/common_ui/screen_manager/screen_manager.dart';

class SelectSkillsScreen extends StatefulWidget {
  final String trackName;
  final List<String> skills;

  const SelectSkillsScreen({
    super.key,
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
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: size.width * 0.02,
                  runSpacing: size.height * 0.015,
                  children: widget.skills.map((skill) {
                    final isSelected = selectedSkills.contains(skill);

                    return GestureDetector(
                      onTap: () {
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
                          skill,
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

            /// 🔥 Continue Button
            SizedBox(
              width: double.infinity,
              height: size.height * 0.065,
              child: ElevatedButton(
                onPressed: () {
                  // Go to ScreenManager using GetX
                  Get.to(ScreenManager(initialIndex: 0));
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
          ],
        ),
      ),
    );
  }
}
