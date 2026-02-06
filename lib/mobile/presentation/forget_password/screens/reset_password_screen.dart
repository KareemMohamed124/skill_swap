import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/reset_password_bloc/reset_password_bloc.dart';
import '../../../../shared/data/models/reset_password/reset_password_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../sign/screens/sign_in_screen.dart';
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

    // نسبي للعرض والطول
    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.02;
    final fieldSpacing = screenHeight * 0.02;
    final titleFontSize = screenWidth * 0.06; // 22px تقريبا على شاشة 360
    final subTitleFontSize = screenWidth * 0.04; // 14-16px
    final buttonHeight = screenHeight * 0.07; // 50px تقريبا
    final borderRadius = screenWidth * 0.02;

    return BlocProvider(
      create: (context) => sl<ResetPasswordBloc>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            const CustomAppBar(title: "Reset Password"),
            Positioned(
              top: screenHeight * 0.1,
              // بدل 80
              left: 0,
              right: 0,
              bottom: 0,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(screenWidth * 0.06),
                            topRight: Radius.circular(screenWidth * 0.06),
                          ),
                        ),
                        child:
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
                              Get.to(SignInScreen());
                            }
                          },
                          builder: (context, state) {
                            return Form(
                              key: formKey,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPadding,
                                    vertical: verticalPadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Create New Password",
                                      style: TextStyle(
                                        fontSize: titleFontSize,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color,
                                      ),
                                    ),
                                    SizedBox(height: fieldSpacing / 2),
                                    Text(
                                      "Enter your new password to continue",
                                      style: TextStyle(
                                          fontSize: subTitleFontSize,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color),
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
                                        if (value !=
                                            newPasswordController.text) {
                                          return "Passwords do not match";
                                        }
                                        return confirmPasswordError;
                                      },
                                    ),
                                    SizedBox(height: fieldSpacing * 1.5),

                                    /// Confirm Button
                                    SizedBox(
                                      width: double.infinity,
                                      height: buttonHeight,
                                      child: CustomButton(
                                        text: state is ResetPasswordLoading
                                            ? "updating"
                                            : "Confirm",
                                        onPressed: state is ResetPasswordLoading
                                            ? null
                                            : () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  final request = ResetPasswordRequest(
                                                      email: widget.email,
                                                      forgetCode: widget.code,
                                                      password:
                                                          newPasswordController
                                                              .text,
                                                      confirmPassword:
                                                          confirmPasswordController
                                                              .text);
                                                  context
                                                      .read<ResetPasswordBloc>()
                                                      .add(
                                                        ConfirmSubmit(request),
                                                      );
                                                }
                                              },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
