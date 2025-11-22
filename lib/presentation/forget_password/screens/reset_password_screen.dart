import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../sign/widgets/custom_appbar.dart';
import '../../sign/widgets/custom_button.dart';
import '../../sign/widgets/custom_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appBar = const CustomAppBar(title: "Reset Password");
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColor.mainColor,
      appBar: appBar,
      body: SingleChildScrollView(
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
                    obscureText: !_isPasswordVisible,
                    // suffixIcon: IconButton(
                    //   icon: Icon(_isPasswordVisible
                    //       ? Icons.visibility
                    //       : Icons.visibility_off),
                    //   onPressed: () {
                    //     setState(() {
                    //       _isPasswordVisible = !_isPasswordVisible;
                    //     });
                    //   },
                    // ),
                  ),
                  const SizedBox(height: 16),

                  /// Confirm Password
                  CustomTextField(
                    controller: confirmPasswordController,
                    labelText: "Confirm Password",
                    hintText: "Re-enter password",
                    obscureText: !_isConfirmPasswordVisible,
                    // suffixIcon: IconButton(
                    //   icon: Icon(_isConfirmPasswordVisible
                    //       ? Icons.visibility
                    //       : Icons.visibility_off),
                    //   onPressed: () {
                    //     setState(() {
                    //       _isConfirmPasswordVisible =
                    //       !_isConfirmPasswordVisible;
                    //     });
                    //   },
                    // ),
                  ),
                  const SizedBox(height: 32),

                  /// Confirm Button
                  CustomButton(
                    text: "Confirm",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (newPasswordController.text !=
                            confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Passwords do not match"),
                            ),
                          );
                          return;
                        }
                        // هنا هتنادي API لتحديث الباسورد
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Password updated successfully"),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}