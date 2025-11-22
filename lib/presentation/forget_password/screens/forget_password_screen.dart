import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/presentation/forget_password/screens/verify_screen.dart';
import 'package:skill_swap/presentation/forget_password/widgets/custom_auth.dart';
import 'package:skill_swap/presentation/sign/screens/sign_in_screen.dart';
import '../../../bloc/send_code_bloc/send_code_bloc.dart';
import '../../../constants/colors.dart';
import '../../../data/models/send_code/send_code_request.dart';
import '../../../dependency_injection/injection.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  String? emailError; // validation + backend error

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SendCodeBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<SendCodeBloc, SendCodeState>(
          listener: (context, state) {
            if (state is SendCodeFailureState) {
              setState(() {
                emailError = null;
                final validationErrors = state.error.validationErrors;
                if (validationErrors != null) {
                  for (var err in validationErrors) {
                    if (err.field.toLowerCase() == "email") {
                      emailError = err.message;
                    }
                  }
                } else {
                  emailError = state.error.message;
                }

              });
            }

            if (state is SendCodeSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.response.message)),
              );

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VerifyScreen(email: emailController.toString(),)),
              );
            }
          },

          builder: (context, state) {
            return CustomAuth(
              title: 'Forgot Password?',
              subTitle: "Enter your email and we'll send you a verification code.",

              childWidget: Form(
                key: formKey,
                child: SizedBox(
                  width: 329,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email Field
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Enter Email Address",
                          filled: true,
                          fillColor: AppColor.grayColor,
                          prefixIcon: const Icon(Icons.email_outlined),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: emailError != null ? Colors.red : Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: emailError != null ? Colors.red : Colors.grey,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (_) {
                          setState(() {
                            emailError = null;
                          });
                        },
                      ),

                      if (emailError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            emailError!,
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              buttonText: "Send Verification Code",
              onPressed: () {
                String email = emailController.text.trim();

                if (email.isEmpty) {
                  setState(() {
                    emailError = "Please fill out this field.";
                  });
                  return;
                } else if (!email.contains("@")) {
                  setState(() {
                    emailError = "Please enter a valid email.";
                  });
                  return;
                } else {
                  setState(() {
                    emailError = null;
                  });

                  final request = SendCodeRequest(email: email);
                  context.read<SendCodeBloc>().add(SendVerificationCode(request));
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
            );
          },
        ),
      ),
    );
  }
}