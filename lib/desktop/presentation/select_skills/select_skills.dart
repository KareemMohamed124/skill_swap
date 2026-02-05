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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              'Select your skills for ${selectedTrack ?? ''}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge!.color
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Write the skills you’ve mastered in the ${selectedTrack ?? ''} track to help us connect you with the right mentors and opportunities.',
              style:  TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyLarge!.color
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 324,
              child: TextField(
                maxLines: null,
                minLines: 8,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).cardColor,
                  hintText: 'Unity, Python, Unreal Engine...',
                  hintStyle: TextStyle(
                    color: const Color(0xFF0D035F).withValues(alpha: 0.25),
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppPalette.primary, width: 1),
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
                const SizedBox(width: 16),
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
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
