import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:skill_swap/presentation/forget_password/screens/email_verification_screen.dart';
import 'package:skill_swap/presentation/sign/widgets/custom_appbar.dart';
import 'package:skill_swap/presentation/sign/widgets/custom_button.dart';
import 'package:skill_swap/presentation/sign/widgets/custom_text_field.dart';
import '../../../bloc/register_bloc/register_bloc.dart';
import '../../../bloc/register_bloc/register_event.dart';
import '../../../bloc/register_bloc/register_state.dart';
import '../../../constants/colors.dart';
import '../../../data/models/register/register_request.dart';
import '../../../dependency_injection/injection.dart';

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
    final appBar = const CustomAppBar(title: "Sign Up");
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => sl<RegisterBloc>(),
      child: Scaffold(
        backgroundColor: AppColor.mainColor,
        appBar: appBar,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
              MediaQuery.of(context).size.height -
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
              child: BlocConsumer<RegisterBloc, RegisterState>(
                listener: (context, state) {
                  if (state is RegisterFailureState) {
                    setState(() {
                      nameError = null;
                      emailError = null;
                      passwordError = null;
                      confirmPasswordError = null;

                      final validationErrors = state.error.validationErrors;
                      if (validationErrors != null) {
                        for (var err in validationErrors) {
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
                      }
                    });
                  } else if (state is RegisterSuccessState) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.data.message)));
                   Get.to(EmailVerificationScreen(email: emailController.text,));
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: formKey,
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

                        CustomTextField(
                          controller: nameController,
                          labelText: "Full Name",
                          hintText: "Enter your full name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Name is required";
                            }
                            if (value.length < 2 || value.length > 20) {
                              return "Name must be between 2 and 20 characters";
                            }
                            if (!RegExp(
                              r'^[a-zA-Z][a-zA-Z0-9]*$',
                            ).hasMatch(value)) {
                              return "Must start with a letter and contain only letters and numbers";
                            }
                            return nameError;
                          },
                        ),
                        const SizedBox(height: 16),

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
                        const SizedBox(height: 16),

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
                              r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}$',
                            ).hasMatch(value)) {
                              return "At least 8 chars, 1 uppercase, 1 lowercase, 1 number";
                            }
                            return passwordError;
                          },
                        ),
                        const SizedBox(height: 16),

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
                              return "Must match password";
                            }
                            return confirmPasswordError;
                          },
                        ),
                        const SizedBox(height: 32),

                        CustomButton(
                          text:
                          state is RegisterLoading
                              ? "Registering..."
                              : "Sign Up",
                          onPressed:
                          state is RegisterLoading
                              ? null
                              : () {
                            if (formKey.currentState!.validate()) {
                              final request = RegisterRequest(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                confirmPassword:
                                confirmPasswordController.text,
                              );
                              context.read<RegisterBloc>().add(
                                RegisterSubmit(request),
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
    );
  }
}