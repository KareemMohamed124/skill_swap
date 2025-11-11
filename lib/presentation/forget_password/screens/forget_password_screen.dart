import 'package:flutter/material.dart';
import 'package:skill_swap/presentation/constants/colors.dart';
import 'package:skill_swap/presentation/forget_password/screens/verify_screen.dart';
import 'package:skill_swap/presentation/forget_password/widgets/CustomAuth.dart';
import 'package:skill_swap/presentation/sign/screens/sign_in_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: CustomAuth(
        title: 'Forgot Password?',
        subTitle: "Enter your email and we'll send you a verification code.",
        childWidget: Form(
          key: formKey,
          child: SizedBox(
            width: 329,
            height: 50,
            child: TextFormField(
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please fill out this field.";
                }
                if (!value.contains("@")) {
                  return "Please enter a valid email.";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Enter Address",
                hintStyle: const TextStyle(color: Colors.black38, fontSize: 15),
                filled: true,
                fillColor: AppColor.grayColor,
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        buttonText: "Send Verification Code",
        onPressed: () {
          if (formKey.currentState!.validate()) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VerifyScreen()),
            );
          }
        },
        bottomText: "Remember your password? ",
        bottomActionText: "Sign In",
        onBottomTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          );
        },
      ),
    );
  }
}
