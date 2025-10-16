import 'package:flutter/material.dart';
import 'package:skill_swap/presentation/sign/screens/sign_up_screen.dart';
import 'package:skill_swap/presentation/sign/widght/custom_appbar.dart';
import 'package:skill_swap/presentation/sign/widght/custom_button.dart';
import 'package:skill_swap/presentation/sign/widght/custom_text_field.dart';
import 'package:skill_swap/presentation/sign/widght/social_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEF5FF),
      appBar: const CustomAppBar(title: "Sign In"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Sign in to continue your learning journey",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 30),

              const CustomTextField(
                labelText: "Email",
                hintText: "Enter your email",
              ),
              const SizedBox(height: 15),

              const CustomTextField(
                labelText: "Password",
                hintText: "Enter your password",
                obscureText: true,
              ),
              const SizedBox(height: 10),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forget Password?",
                    style: TextStyle(color: Color(0xff1C54F4)),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              const CustomButton(text: "Sign In"),
              const SizedBox(height: 20),

              const Row(
                children: [
                  Expanded(
                    child: Divider(thickness: 2, color: Color(0xff142057)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "Or continue with",
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
                      "Don’t have an account? ",
                      style: TextStyle(color: Color(0xff142057)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
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
