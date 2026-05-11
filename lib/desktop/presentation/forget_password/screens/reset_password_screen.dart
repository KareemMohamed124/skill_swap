import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/reset_password_bloc/reset_password_bloc.dart';
import '../../../../shared/data/models/reset_password/reset_password_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../sign/screens/sign_in_screen.dart';
<<<<<<< HEAD
import '../../sign/widgets/custom_button.dart';
import '../../sign/widgets/custom_text_field.dart';

class ResetPasswordDesktop extends StatefulWidget {
  final String email;
  final String code;

  const ResetPasswordDesktop({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<ResetPasswordDesktop> createState() => _ResetPasswordDesktopState();
}

class _ResetPasswordDesktopState extends State<ResetPasswordDesktop> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ResetPasswordBloc>(),
      child: Scaffold(
        body: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error.message)),
              );
            }

            if (state is ResetPasswordSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.data.message)),
              );

              Get.offAll(() => const SignInDesktop());
            }
          },
          builder: (context, state) {
            final isLoading = state is ResetPasswordLoading;

            return Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 450,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withValues(alpha: 0.5),
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black12,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Create New Password",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Enter your new password to continue",
                          style: TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 32),

                        /// New Password
                        CustomTextField(
                          controller: newPasswordController,
                          labelText: "New Password",
                          hintText: "Enter new password",
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (!RegExp(
                              r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$",
                            ).hasMatch(value)) {
                              return "Password must be 8+ chars, upper, lower & number";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        /// Confirm Password
                        CustomTextField(
                          controller: confirmPasswordController,
                          labelText: "Confirm Password",
                          hintText: "Re-enter password",
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Confirm password is required";
                            }
                            if (value != newPasswordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 32),

                        /// Button
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: isLoading ? "Updating..." : "Confirm",
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      final request = ResetPasswordRequest(
                                        email: widget.email,
                                        forgetCode: widget.code,
                                        password: newPasswordController.text,
                                        confirmPassword:
                                            confirmPasswordController.text,
                                      );

                                      context
                                          .read<ResetPasswordBloc>()
                                          .add(ConfirmSubmit(request));
                                    }
                                  },
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
=======
import '../../sign/widgets/custom_appbar.dart';
import '../../sign/widgets/custom_button.dart';
import '../../sign/widgets/custom_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String code;

  const ResetPasswordScreen(
      {super.key, required this.email, required this.code});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? passwordError;
  String? confirmPasswordError;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.02;
    final fieldSpacing = screenHeight * 0.02;
    final titleFontSize = screenWidth * 0.06;
    final subTitleFontSize = screenWidth * 0.04;
    final buttonHeight = screenHeight * 0.07;

    return BlocProvider(
      create: (context) => sl<ResetPasswordBloc>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(title: "Reset Password"),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "Create New Password",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                SizedBox(height: fieldSpacing / 2),
                Text(
                  "Enter your new password to continue",
                  style: TextStyle(
                    fontSize: subTitleFontSize,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
                SizedBox(height: fieldSpacing),

                /// New Password
                CustomTextField(
                  controller: newPasswordController,
                  labelText: "New Password",
                  hintText: "Enter new password",
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    } else if (!RegExp(
                      r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$",
                    ).hasMatch(value)) {
                      return "Password must contain at least 8 characters, uppercase, lowercase, and a number";
                    } else if (value.length < 8) {
                      return "Password must be at least 8 characters";
                    }
                    return passwordError;
                  },
                ),
                SizedBox(height: fieldSpacing),

                /// Confirm Password
                CustomTextField(
                  controller: confirmPasswordController,
                  labelText: "Confirm Password",
                  hintText: "Re-enter password",
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm password is required";
                    }
                    if (value != newPasswordController.text) {
                      return "Passwords do not match";
                    }
                    return confirmPasswordError;
                  },
                ),
                SizedBox(height: fieldSpacing * 1.5),

                /// Confirm Button
                BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
                  listener: (context, state) {
                    if (state is ResetPasswordFailureState) {
                      setState(() {
                        passwordError = null;
                        confirmPasswordError = null;

                        final errors = state.error.validationErrors;
                        if (errors != null && errors.isNotEmpty) {
                          for (var err in errors) {
                            switch (err.field) {
                              case "password":
                                passwordError = err.message;
                                break;
                              case "confirmPassword":
                                confirmPasswordError = err.message;
                                break;
                            }
                          }
                        } else {
                          passwordError = state.error.message;
                        }
                      });
                      formKey.currentState?.validate();
                    } else if (state is ResetPasswordSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.data.message)));
                      Get.to(SignInDesktop());
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: buttonHeight,
                      child: CustomButton(
                        text: state is ResetPasswordLoading
                            ? "Updating..."
                            : "Confirm",
                        onPressed: state is ResetPasswordLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  final request = ResetPasswordRequest(
                                    email: widget.email,
                                    forgetCode: widget.code,
                                    password: newPasswordController.text,
                                    confirmPassword:
                                        confirmPasswordController.text,
                                  );
                                  context
                                      .read<ResetPasswordBloc>()
                                      .add(ConfirmSubmit(request));
                                }
                              },
                      ),
                    );
                  },
                ),
                SizedBox(height: fieldSpacing),
              ],
            ),
          ),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        ),
      ),
    );
  }
}
