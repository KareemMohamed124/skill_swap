import 'package:flutter/material.dart';
import 'package:skill_swap/presentation/forget_password/screens/verify_screen.dart';
import 'package:skill_swap/presentation/forget_password/widgets/custom_auth.dart';
import 'package:skill_swap/presentation/sign/screens/sign_in_screen.dart';
import '../../../constants/colors.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  String? errorMsg;

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
            height: errorMsg == null ? 50 : 66,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Enter Address",
                      filled: true,
                      fillColor: AppColor.grayColor,

                      prefixIcon: const Icon(Icons.email_outlined),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: errorMsg == null ? Colors.grey : Colors.red,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: errorMsg == null ? Colors.grey : Colors.red,
                          width: 1.5,
                        ),
                      ),
                      errorText: null,
                    ),
                    onChanged: (_) {
                      setState(() {
                        errorMsg = null;
                      });
                    },
                  ),
                ),

                SizedBox(
                  height: errorMsg == null ? 0 : 16,
                  child: errorMsg == null
                      ? const SizedBox()
                      : Text(
                    errorMsg!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),

        buttonText: "Send Verification Code",
        onPressed: () {
          String email = emailController.text;

          setState(() {
            if (email.isEmpty) {
              errorMsg = "Please fill out this field.";
            } else if (!email.contains("@")) {
              errorMsg = "Please enter a valid email.";
            } else {
              errorMsg = null;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VerifyScreen()),
              );
            }
          });
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