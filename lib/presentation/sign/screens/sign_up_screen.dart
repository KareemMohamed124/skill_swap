import 'package:flutter/material.dart';
import 'package:skill_swap/presentation/sign/screens/sign_in_screen.dart';
import 'package:skill_swap/presentation/sign/widght/custom_appbar.dart';
import 'package:skill_swap/presentation/sign/widght/custom_button.dart';
import 'package:skill_swap/presentation/sign/widght/custom_text_field.dart';
import 'package:skill_swap/presentation/sign/widght/social_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEF5FF),
      appBar: const CustomAppBar(title: "Sign Up"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Join us and start your learning journey today!",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 30),

              const CustomTextField(
                labelText: "Full Name",
                hintText: "Enter your full name",
              ),
              const SizedBox(height: 15),

              const CustomTextField(
                labelText: "Email",
                hintText: "Enter your email",
              ),
              const SizedBox(height: 15),

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
              const SizedBox(height: 20),

              const CustomButton(text: "Sign Up"),
              const SizedBox(height: 20),

              const Row(
                children: [
                  Expanded(
                    child: Divider(thickness: 2, color: Color(0xff142057)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "Or sign up with",
                      style: TextStyle(color: Color(0xff142057)),
                    ),
                  ),
                  Expanded(
                    child: Divider(thickness: 2, color: Color(0xff142057)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton(text: "Google"),
                  SizedBox(width: 10),
                  SocialButton(text: "GitHub"),
                ],
              ),
              const SizedBox(height: 30),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Color(0xff142057)),
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
                        style: TextStyle(color: Color(0xff1C54F4)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
