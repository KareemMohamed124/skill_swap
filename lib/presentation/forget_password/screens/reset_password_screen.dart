import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/data/models/reset_password/reset_password_request.dart';
import '../../../bloc/reset_password_bloc/reset_password_bloc.dart';
import '../../../constants/colors.dart';
import '../../../dependency_injection/injection.dart';
import '../../sign/widgets/custom_appbar.dart';
import '../../sign/widgets/custom_button.dart';
import '../../sign/widgets/custom_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String code;
  const ResetPasswordScreen({super.key, required this.email, required this.code});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? passwordError;
  String? confirmPasswordError;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appBar = const CustomAppBar(title: "Reset Password");
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
  create: (context) => sl<ResetPasswordBloc>(),
  child: Scaffold(
      backgroundColor: AppColor.mainColor,
      appBar: appBar,
      body: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
  listener: (context, state) {
    if (state is ResetPasswordFailureState) {
      setState(() {
        passwordError = null;
        confirmPasswordError = null;

        final validationErrors = state.error.validationErrors;
        if (validationErrors != null) {
          for (var err in validationErrors) {
            switch (err.field) {
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
    } else if (state is ResetPasswordSuccessState) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.data.message)));
    }
  },
  builder: (context, state) {
    return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Create New Password",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Enter your new password to continue",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 32),

                  /// New Password
                  CustomTextField(
                    controller: newPasswordController,
                    labelText: "New Password",
                    hintText: "Enter new password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      } else if (!RegExp(
                        r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$",
                      ).hasMatch(value)) {
                        return "Password must contain uppercase, lowercase, and a number";
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
                  const SizedBox(height: 32),

                  /// Confirm Button
                  CustomButton(
                    text: state is ResetPasswordLoading ? "updating" : "Confirm",
                    onPressed: state is ResetPasswordLoading ? null : () {
                      if (_formKey.currentState!.validate()) {
                        final request = ResetPasswordRequest(
                            email: widget.email,
                            forgetCode: widget.code,
                            password: newPasswordController.text,
                            confirmPassword: confirmPasswordController.text
                        );
                        context.read<ResetPasswordBloc>().add(
                          ConfirmSubmit(request),
                        );

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     content: Text("Password updated successfully"),
                        //   ),
                        // );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  },
),
    ),
);
  }
}