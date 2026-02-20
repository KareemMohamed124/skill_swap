import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../../../shared/bloc/register_bloc/register_bloc.dart';
import '../../../../shared/bloc/register_bloc/register_event.dart';
import '../../../../shared/bloc/register_bloc/register_state.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;

    double titleFontSize = 22;
    double subtitleFontSize = 16;
    double verticalSpacing = 32;
    double formSpacing = 16;
    double paddingAll = 16;

    if (screenWidth >= 800) {
      titleFontSize = 28;
      subtitleFontSize = 18;
      verticalSpacing = 40;
      formSpacing = 20;
      paddingAll = 24;
    }

    return BlocProvider(
      create: (_) => sl<RegisterBloc>(),
      child: BaseScreen(
        title: "Sign Up",
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            /// ===== FAILURE =====
            if (state is RegisterFailureState) {
              setState(() {
                nameError = null;
                emailError = null;
                passwordError = null;
                confirmPasswordError = null;

                final errors = state.error.validationErrors ?? [];

                if (errors.isNotEmpty) {
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
                  emailError = state.error.message ?? "Registration failed";
                }
              });

              formKey.currentState?.validate();
            }

            /// ===== SUCCESS =====
            if (state is RegisterSuccessState) {
              final message = state.data?.message ?? "Registered successfully";

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );

              Get.to(
                EmailVerificationScreen(
                  email: emailController.text,
                  password: passwordController.text,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(paddingAll),
              child: Form(
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
                      ),
                    ),
                    SizedBox(height: formSpacing / 2),
                    Text(
                      "Join us and start your learning journey today!",
                      style: TextStyle(fontSize: subtitleFontSize),
                    ),
                    SizedBox(height: verticalSpacing),

                    /// Name
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
                        if (value.length < 2 || value.length > 20) {
                          return "Name must be between 2 and 20 characters";
                        }
                        return nameError;
                      },
                    ),

                    SizedBox(height: formSpacing),

                    /// Email
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

                    /// Password
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
                          return "Password must contain at least 8 characters, uppercase, lowercase, and a number";
                        }
                        return passwordError;
                      },
                    ),

                    SizedBox(height: formSpacing),

                    /// Confirm Password
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

                    /// Button
                    CustomButton(
                      text: state is RegisterLoading
                          ? "Registering..."
                          : "Sign Up",
                      onPressed: state is RegisterLoading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                context.read<RegisterBloc>().add(
                                      RegisterSubmit(
                                        RegisterRequest(
                                          name: nameController.text,
                                          email: emailController.text,
                                          password: passwordController.text,
                                          confirmPassword:
                                              confirmPasswordController.text,
                                        ),
                                      ),
                                    );
                              }
                            },
                    ),

                    SizedBox(height: verticalSpacing),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
