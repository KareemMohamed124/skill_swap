import 'package:flutter/material.dart';
import 'package:skill_swap/presentation/select_skills/select_track.dart';
import 'package:skill_swap/presentation/sign/screens/sign_up_screen.dart';
import 'package:skill_swap/presentation/sign/widgets/custom_button.dart';

import '../../constants/colors.dart';

class SelectSkills extends StatelessWidget {
  const SelectSkills({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32,),
            const Text(
              'Select your skills',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColor.blackColor
              ),
            ),
            const SizedBox(height: 16,),
            const Text(
              'Write the skills you’ve mastered in the Gaming track to help us connect you with the right mentors and opportunities.',
              style: TextStyle(
                  fontSize: 16,
                  color: AppColor.mainColor
              ),
            ),
            const SizedBox(height: 32,),
            SizedBox(
              height: 324,
              child: TextField(
                maxLines: null,
                minLines: 8,
                decoration: InputDecoration(
                    hintText: 'Unity, Python, Unreal Engine...',
                    hintStyle: TextStyle(
                        color: Color(0xFF0D035F).withValues(alpha: 0.25),
                        fontSize: 16
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppColor.mainColor,
                          width: 1,
                        )
                    )
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  text: 'Skip',
                  widthButton: 172, onPressed: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectTrack()),
                ); },
                ),
                const SizedBox(height: 16,),
                CustomButton(
                  text: 'Continue',
                  widthButton: 172, onPressed: () { // Home
                     },
                ),
              ],
            ),
            const SizedBox(height: 32,),
          ],
        ),
      )
    );
  }
}