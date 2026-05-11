import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/sign/screens/sign_in_screen.dart';

import '../../../../desktop/presentation/sign/widgets/custom_text_field.dart';
import '../../../../shared/bloc/change_password_bloc/change_password_bloc.dart';
<<<<<<< HEAD
=======
import '../../../../shared/common_ui/base_screen.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import '../../../../shared/data/models/change_password/change_password_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../forget_password/screens/forget_password_screen.dart';
import '../../sign/widgets/custom_button.dart';

<<<<<<< HEAD
class ChangePasswordDesktop extends StatefulWidget {
  const ChangePasswordDesktop({super.key});

  @override
  State<ChangePasswordDesktop> createState() => _ChangePasswordDesktopState();
}

class _ChangePasswordDesktopState extends State<ChangePasswordDesktop> {
=======
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? oldPasswordError;
  String? passwordError;
  String? confirmPasswordError;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return BlocProvider(
      create: (_) => sl<ChangePasswordBloc>(),
      child: Scaffold(
        body: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordFailureState) {
              Get.snackbar('Error', state.error.message);

=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
                        break;
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD

              formKey.currentState?.validate();
            }

            if (state is ChangePasswordSuccessState) {
=======
              formKey.currentState?.validate();
            } else if (state is ChangePasswordSuccessState) {
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              Get.snackbar('Success', state.success.message);
              Get.to(SignInDesktop());
            }
          },
          builder: (context, state) {
<<<<<<< HEAD
            final isLoading = state is ChangePasswordLoading;

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
=======
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(paddingAll),
                child: Form(
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
<<<<<<< HEAD
                        const Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Update your password to keep your account secure",
                          style: TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 32),

                        /// Old Password
=======
                        ///Old Password
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                        CustomTextField(
                          controller: oldPasswordController,
                          labelText: "Old Password",
                          hintText: "Enter old password",
                          obscureText: true,
<<<<<<< HEAD
                          errorText: oldPasswordError,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Old password is required";
                            }

                            return null;
                          },
                        ),

=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                        const SizedBox(height: 16),

                        /// New Password
                        CustomTextField(
                          controller: newPasswordController,
                          labelText: "New Password",
                          hintText: "Enter new password",
                          obscureText: true,
<<<<<<< HEAD
                          errorText: passwordError,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (!RegExp(
                              r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$",
                            ).hasMatch(value)) {
                              return "Password must contain uppercase, lowercase and number";
                            }
                            return null;
                          },
                        ),

=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                        const SizedBox(height: 16),

                        /// Confirm Password
                        CustomTextField(
                          controller: confirmPasswordController,
                          labelText: "Confirm Password",
                          hintText: "Re-enter password",
                          obscureText: true,
<<<<<<< HEAD
                          errorText: confirmPasswordError,
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Confirm password is required";
                            }
                            if (value != newPasswordController.text) {
                              return "Passwords do not match";
                            }
<<<<<<< HEAD
                            return null;
                          },
                        ),

                        const SizedBox(height: 32),

                        /// Button
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: isLoading ? "Changing..." : "Change Password",
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      context.read<ChangePasswordBloc>().add(
                                            ConfirmSubmit(
                                              ChangePasswordRequest(
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                                                oldPassword:
                                                    oldPasswordController.text
                                                        .trim(),
                                                newPassword:
                                                    newPasswordController.text
                                                        .trim(),
                                                confirmPassword:
                                                    confirmPasswordController
                                                        .text
<<<<<<< HEAD
                                                        .trim(),
                                              ),
                                            ),
                                          );
                                    }
                                  },
                          ),
                        ),

                        const SizedBox(height: 20),

                        Center(
                          child: GestureDetector(
                            onTap: () => Get.to(ForgetPasswordDesktop()),
                            child: const Text(
                              "Forget Old Password?",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                              ),
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                            ),
                          ),
                        ),
                      ],
<<<<<<< HEAD
                    ),
                  ),
                ),
=======
                    )),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              ),
            );
          },
        ),
      ),
    );
  }
}
