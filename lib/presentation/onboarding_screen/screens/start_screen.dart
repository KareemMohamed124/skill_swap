import 'package:flutter/material.dart';
import 'package:skill_swap/constants/colors.dart';
import 'package:skill_swap/presentation/sign/screens/sign_up_screen.dart';

import '../../sign/screens/sign_in_screen.dart';
import '../../sign/widgets/custom_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Spacer(),
            Image.asset(
              'assets/logo/logoStart.png',
            ),

            const SizedBox(height: 16),

            Text(
              'Welcome to \nSkillSwap',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColor.mainColor,
              ),
            ),

            const SizedBox(height: 64),


            Text(
              'Learn new skills, teach others, and grow together in our collaborative learning community',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                height: 1.4,
                color: AppColor.blackColor,
              ),
            ),

           Spacer(),
            CustomButton(text: 'Get Start', onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            },),

            const SizedBox(height: 16),

            CustomButton(
                text: 'I already have an account',
                colorButton: AppColor.whiteColor,
              colorText: AppColor.mainColor, onPressed: () {
                  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            ); },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}