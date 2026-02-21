import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/sign/screens/sign_in_screen.dart';

import '../../../../desktop/presentation/sign/widgets/custom_text_field.dart';
import '../../../../shared/bloc/change_password_bloc/change_password_bloc.dart';
import '../../../../shared/common_ui/base_screen.dart';
import '../../../../shared/data/models/change_password/change_password_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../forget_password/screens/forget_password_screen.dart';
import '../../sign/widgets/custom_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? oldPasswordError;
  String? passwordError;
  String? confirmPasswordError;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double titleFontSize = 22;
    double subtitleFontSize = 16;
    double paddingAll = 16;
    double spacing = 32;

    if (screenWidth >= 800) {
      titleFontSize = 28;
      subtitleFontSize = 18;
      paddingAll = 24;
      spacing = 40;
    }

    return BlocProvider(
      create: (_) => sl<ChangePasswordBloc>(),
      child: BaseScreen(
        title: "Change Password",
        child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
          listener: (context, state) async {
            if (state is ChangePasswordFailureState) {
              Get.snackbar('Error', state.error.message);
              setState(() {
                oldPasswordError = null;
                passwordError = null;
                confirmPasswordError = null;

                final errors = state.error.validationErrors;
                if (errors != null && errors.isNotEmpty) {
                  for (var err in errors) {
                    switch (err.field) {
                      case "oldPassword":
                        oldPasswordError = err.message;
                      case "newPassword":
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
            } else if (state is ChangePasswordSuccessState) {
              Get.snackbar('Success', state.success.message);
              Get.to(SignInScreen());
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(paddingAll),
                child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///Old Password
                        CustomTextField(
                          controller: oldPasswordController,
                          labelText: "Old Password",
                          hintText: "Enter old password",
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Old password is required";
                            } else if (!RegExp(
                              r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$",
                            ).hasMatch(value)) {
                              return "Password must contain at least 8 characters, uppercase, lowercase, and a number";
                            } else if (value.length < 8) {
                              return "Password must be at least 8 characters";
                            }
                            return oldPasswordError;
                          },
                        ),
                        const SizedBox(height: 16),

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
                            return confirmPasswordError;
                          },
                        ),
                        const SizedBox(height: 24),

                        /// Confirm Button
                        CustomButton(
                          text: state is ChangePasswordLoading
                              ? "Changing..."
                              : "Change Password",
                          onPressed: state is ChangePasswordLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<ChangePasswordBloc>().add(
                                          ConfirmSubmit(
                                            ChangePasswordRequest(
                                                oldPassword:
                                                    oldPasswordController.text
                                                        .trim(),
                                                newPassword:
                                                    newPasswordController.text
                                                        .trim(),
                                                confirmPassword:
                                                    confirmPasswordController
                                                        .text
                                                        .trim()),
                                          ),
                                        );
                                  }
                                },
                        ),
                        const SizedBox(height: 16),

                        Center(
                          child: TextButton(
                            onPressed: () => Get.to(ForgetPassword()),
                            child: Text(
                              "Forget Old Password?",
                              style: TextStyle(fontSize: subtitleFontSize),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            );
          },
        ),
      ),
    );
  }
}
