import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:skill_swap/common_ui/screen_manager/screen_manager.dart';
import 'package:skill_swap/presentation/home/screens/home_screen.dart';
import 'package:skill_swap/presentation/select_skills/select_track.dart';
import 'package:skill_swap/presentation/sign/widgets/custom_button.dart';
import '../../constants/colors.dart';

class SelectSkills extends StatelessWidget {
  final String? selectedTrack;

  const SelectSkills({super.key, this.selectedTrack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              'Select your skills for ${selectedTrack ?? ''}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.blackColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Write the skills you’ve mastered in the ${selectedTrack ?? ''} track to help us connect you with the right mentors and opportunities.',
              style: const TextStyle(fontSize: 16, color: AppColor.mainColor),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 324,
              child: TextField(
                maxLines: null,
                minLines: 8,
                decoration: InputDecoration(
                  hintText: 'Unity, Python, Unreal Engine...',
                  hintStyle: TextStyle(
                    color: const Color(0xFF0D035F).withValues(alpha: 0.25),
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColor.mainColor, width: 1),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  text: 'Skip',
                  widthButton: 172,
                  onPressed: () {
                   Get.to(ScreenManager(initialIndex: 0,));
                  },
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Continue',
                  widthButton: 172,
                  onPressed: () {
                    Get.to(ScreenManager(initialIndex: 0,));
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
