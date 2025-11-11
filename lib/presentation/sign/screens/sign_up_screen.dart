import 'package:flutter/material.dart';
import 'package:skill_swap/presentation/constants/colors.dart';
import 'package:skill_swap/presentation/sign/screens/sign_in_screen.dart';
import 'package:skill_swap/presentation/sign/widght/custom_appbar.dart';
import 'package:skill_swap/presentation/sign/widght/custom_button.dart';
import 'package:skill_swap/presentation/sign/widght/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appBar = const CustomAppBar(title: "Sign Up");
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: mainColor,
      appBar: appBar,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top,
          ),
          child: Container(
            width: screenWidth,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Join us and start your learning journey today!",
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 32),

                const CustomTextField(
                  labelText: "Full Name",
                  hintText: "Enter your full name",
                ),
                const SizedBox(height: 16),

                const CustomTextField(
                  labelText: "Email",
                  hintText: "Enter your email",
                ),
                const SizedBox(height: 16),

                const CustomTextField(
                  labelText: "Password",
                  hintText: "Create a password",
                  obscureText: true,
                ),
                const SizedBox(height: 15),

                const CustomTextField(
                  labelText: "Confirm Password",
                  hintText: "Confirm your password",
                  obscureText: true,
                ),
                const SizedBox(height: 32),

                const CustomButton(text: "Sign Up"),
                const SizedBox(height: 32),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: mainColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignInScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(color: mainColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}