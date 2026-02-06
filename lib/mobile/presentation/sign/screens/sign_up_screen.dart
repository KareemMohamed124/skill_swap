import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/register_bloc/register_bloc.dart';
import '../../../../shared/bloc/register_bloc/register_event.dart';
import '../../../../shared/bloc/register_bloc/register_state.dart';
import '../../../../shared/common_ui/header.dart';
import '../../../../shared/data/models/register/register_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../forget_password/screens/email_verification_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // MediaQuery values for responsiveness (Mobile + Tablet)
    double titleFontSize = 22;
    double subtitleFontSize = 16;
    double verticalSpacing = 32;
    double formSpacing = 16;
    double paddingAll = 16;
    double transformOffset = screenHeight * 0.045;

    if (screenWidth >= 800) {
      // Tablet
      titleFontSize = 28;
      subtitleFontSize = 18;
      verticalSpacing = 40;
      formSpacing = 20;
      paddingAll = 24;
      transformOffset = screenHeight * 0.048;
    }

    return BlocProvider(
      create: (_) => sl<RegisterBloc>(),
      child: Scaffold(
        body: Column(
          children: [
            /// ===== Header =====
            const CustomAppBar(title: "Sign Up"),

            /// ===== Content =====
            Expanded(
              child: Transform.translate(
                offset: Offset(0, -transformOffset),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: screenHeight -
                            kToolbarHeight -
                            MediaQuery.of(context).padding.top,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(paddingAll),
                        child: BlocConsumer<RegisterBloc, RegisterState>(
                          listener: (context, state) {
                            if (state is RegisterFailureState) {
                              setState(() {
                                nameError = null;
                                emailError = null;
                                passwordError = null;
                                confirmPasswordError = null;

                                final errors = state.error.validationErrors;
                                if (errors != null && errors.isNotEmpty) {
                                  for (var err in errors) {
                                    switch (err.field) {
                                      case "name":
                                        nameError = err.message;
                                        break;
                                      case "email":
                                        emailError = err.message;
                                        break;
                                      case "password":
                                        passwordError = err.message;
                                        break;
                                      case "confirmPassword":
                                        confirmPasswordError = err.message;
                                        break;
                                    }
                                  }
                                } else {
                                  emailError = state.error.message;
                                }
                              });

                              formKey.currentState?.validate();
                            }

                            if (state is RegisterSuccessState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.data.message),
                                ),
                              );

                              Get.to(
                                EmailVerificationScreen(
                                  email: emailController.text,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            return Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: verticalSpacing),
                                  Text(
                                    "Create Account",
                                    style: TextStyle(
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                    ),
                                  ),
                                  SizedBox(height: formSpacing / 2),
                                  Text(
                                    "Join us and start your learning journey today!",
                                    style: TextStyle(
                                      fontSize: subtitleFontSize,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color,
                                    ),
                                  ),
                                  SizedBox(height: verticalSpacing),
                                  CustomTextField(
                                    controller: nameController,
                                    labelText: "Full Name",
                                    hintText: "Enter your full name",
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Name is required";
                                      }
                                      if (RegExp(r'^\d').hasMatch(value)) {
                                        return "Name cannot start with a number";
                                      }
                                      if (value.length < 2 ||
                                          value.length > 20) {
                                        return "Name must be between 2 and 20 characters";
                                      }
                                      return nameError;
                                    },
                                  ),
                                  SizedBox(height: formSpacing),
                                  CustomTextField(
                                    controller: emailController,
                                    labelText: "Email",
                                    hintText: "Enter your email",
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Email is required";
                                      }
                                      if (!RegExp(
                                        r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$",
                                      ).hasMatch(value)) {
                                        return "Enter a valid email";
                                      }
                                      return emailError;
                                    },
                                  ),
                                  SizedBox(height: formSpacing),
                                  CustomTextField(
                                    controller: passwordController,
                                    labelText: "Password",
                                    hintText: "Create a password",
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Password is required";
                                      }
                                      if (!RegExp(
                                        r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$",
                                      ).hasMatch(value)) {
                                        return "Password must contain at least 8 character, uppercase, lowercase, and a number";
                                      }
                                      return passwordError;
                                    },
                                  ),
                                  SizedBox(height: formSpacing),
                                  CustomTextField(
                                    controller: confirmPasswordController,
                                    labelText: "Confirm Password",
                                    hintText: "Confirm your password",
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Confirm password is required";
                                      }
                                      if (value != passwordController.text) {
                                        return "Passwords do not match";
                                      }
                                      return confirmPasswordError;
                                    },
                                  ),
                                  SizedBox(height: verticalSpacing),
                                  CustomButton(
                                    text: state is RegisterLoading
                                        ? "Registering..."
                                        : "Sign Up",
                                    onPressed: state is RegisterLoading
                                        ? null
                                        : () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              context.read<RegisterBloc>().add(
                                                    RegisterSubmit(
                                                      RegisterRequest(
                                                        name:
                                                            nameController.text,
                                                        email: emailController
                                                            .text,
                                                        password:
                                                            passwordController
                                                                .text,
                                                        confirmPassword:
                                                            confirmPasswordController
                                                                .text,
                                                      ),
                                                    ),
                                                  );
                                            }
                                          },
                                  ),
                                  SizedBox(height: verticalSpacing),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
