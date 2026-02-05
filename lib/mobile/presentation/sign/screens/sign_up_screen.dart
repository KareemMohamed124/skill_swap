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
                offset: Offset(0, -screenHeight * 0.045), // ⬅️ الطلوع الآمن
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
                        minHeight:
                        screenHeight -
                            kToolbarHeight -
                            MediaQuery.of(context).padding.top,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child:
                        BlocConsumer<RegisterBloc, RegisterState>(
                          listener: (context, state) {
                            if (state is RegisterFailureState) {
                              setState(() {
                                nameError = null;
                                emailError = null;
                                passwordError = null;
                                confirmPasswordError = null;

                                final errors =
                                    state.error.validationErrors;

                                if (errors != null &&
                                    errors.isNotEmpty) {
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
                                        confirmPasswordError =
                                            err.message;
                                        break;
                                    }
                                  }
                                } else {
                                  emailError =
                                      state.error.message;
                                }
                              });

                              formKey.currentState?.validate();
                            }

                            if (state is RegisterSuccessState) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content:
                                  Text(state.data.message),
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
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 24),

                                  Text(
                                    "Create Account",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight:
                                      FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Join us and start your learning journey today!",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color,
                                    ),
                                  ),

                                  const SizedBox(height: 32),

                                  CustomTextField(
                                    controller: nameController,
                                    labelText: "Full Name",
                                    hintText:
                                    "Enter your full name",
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        return "Name is required";
                                      }
                                      if (RegExp(r'^\d')
                                          .hasMatch(value)) {
                                        return "Name cannot start with a number";
                                      }
                                      if (value.length < 2 ||
                                          value.length > 20) {
                                        return "Name must be between 2 and 20 characters";
                                      }
                                      return nameError;
                                    },
                                  ),

                                  const SizedBox(height: 16),

                                  CustomTextField(
                                    controller:
                                    emailController,
                                    labelText: "Email",
                                    hintText:
                                    "Enter your email",
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
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

                                  const SizedBox(height: 16),

                                  CustomTextField(
                                    controller:
                                    passwordController,
                                    labelText: "Password",
                                    hintText:
                                    "Create a password",
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
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

                                  const SizedBox(height: 16),

                                  CustomTextField(
                                    controller:
                                    confirmPasswordController,
                                    labelText:
                                    "Confirm Password",
                                    hintText:
                                    "Confirm your password",
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        return "Confirm password is required";
                                      }
                                      if (value !=
                                          passwordController
                                              .text) {
                                        return "Passwords do not match";
                                      }
                                      return confirmPasswordError;
                                    },
                                  ),

                                  const SizedBox(height: 32),

                                  CustomButton(
                                    text: state
                                    is RegisterLoading
                                        ? "Registering..."
                                        : "Sign Up",
                                    onPressed:
                                    state is RegisterLoading
                                        ? null
                                        : () {
                                      if (formKey
                                          .currentState!
                                          .validate()) {
                                        context
                                            .read<
                                            RegisterBloc>()
                                            .add(
                                          RegisterSubmit(
                                            RegisterRequest(
                                              name:
                                              nameController
                                                  .text,
                                              email:
                                              emailController
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