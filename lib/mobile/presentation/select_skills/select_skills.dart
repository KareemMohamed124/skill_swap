import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/common_ui/screen_manager/screen_manager.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../sign/widgets/custom_button.dart';

class SelectSkills extends StatelessWidget {
  final String? selectedTrack;

  const SelectSkills({super.key, this.selectedTrack});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04), // responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.04),
            Text(
              'Select your skills for ${selectedTrack ?? ''}',
              style: TextStyle(
                fontSize: screenWidth * 0.06, // responsive font size
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Write the skills you’ve mastered in the ${selectedTrack ?? ''} track to help us connect you with the right mentors and opportunities.',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            SizedBox(
              height: screenHeight * 0.45, // responsive height
              child: TextField(
                maxLines: null,
                minLines: 8,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).cardColor,
                  hintText: 'Unity, Python, Unreal Engine...',
                  hintStyle: TextStyle(
                    color: const Color(0xFF0D035F).withOpacity(0.25),
                    fontSize: screenWidth * 0.04,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                    borderSide: BorderSide(
                        color: AppPalette.primary, width: screenWidth * 0.003),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Skip',
                    onPressed: () {
                      Get.to(ScreenManager(initialIndex: 0));
                    },
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: CustomButton(
                    text: 'Continue',
                    onPressed: () {
                      Get.to(ScreenManager(initialIndex: 0));
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }
}
