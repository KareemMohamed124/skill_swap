import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/sign/screens/sign_up_screen.dart';
import '../../../../shared/bloc/login_bloc/login_bloc.dart';
import '../../../../shared/bloc/login_bloc/login_event.dart';
import '../../../../shared/bloc/login_bloc/login_state.dart';
import '../../../../shared/common_ui/header.dart';
import '../../../../shared/common_ui/screen_manager/screen_manager.dart';
import '../../../../shared/data/models/login/login_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../../../shared/domain/repositories/auth_repository.dart';
import '../../../../shared/helper/local_storage.dart';
import '../../forget_password/screens/forget_password_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  void _clearErrors() {
    emailError = null;
    passwordError = null;
  }

  void _handleServerError(LoginFailureState state) {
    _clearErrors();

    if (state.error.message == "Invalid Login Data") {
      passwordError = "Password is not correct";
    } else if (state.error.message == "Not Register Account") {
      emailError = "Email is not registered";
    }

    final validationErrors = state.error.validationErrors;
    if (validationErrors != null) {
      for (var err in validationErrors) {
        switch (err.field) {
          case "email":
            emailError = err.message;
            break;
          case "password":
            passwordError = err.message;
            break;
        }
      }
    }
  }

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
      create: (_) => sl<LoginBloc>(),
      child: Scaffold(
        body: Column(
          children: [
            /// ===== Header =====
            const CustomAppBar(title: "Sign In"),

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
                        child: BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) async {
                            if (state is LoginFailureState) {
                              setState(() {
                                _handleServerError(state);
                              });
                            } else if (state is LoginSuccessState) {
                              await LocalStorage.saveToken(
                                  state.data.accessToken);
                              final repo = sl<AuthRepository>();
                              final user = await repo.getProfile();
                              await LocalStorage.saveUser(user);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.data.message),
                                ),
                              );

                              Get.to(
                                ScreenManager(initialIndex: 0),
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
                                    "Welcome Back!",
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
                                    "Sign in to continue your learning journey",
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
                                    controller: emailController,
                                    labelText: "Email",
                                    hintText: "Enter your email",
                                    errorText: emailError,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Email is required";
                                      }
                                      if (!RegExp(
                                        r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$",
                                      ).hasMatch(value)) {
                                        return "Enter a valid email";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: formSpacing),
                                  CustomTextField(
                                    controller: passwordController,
                                    labelText: "Password",
                                    hintText: "Enter your password",
                                    obscureText: true,
                                    errorText: passwordError,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Password is required";
                                      }
                                      if (!RegExp(
                                        r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$",
                                      ).hasMatch(value)) {
                                        return "Password must contain at least 8 character, uppercase, lowercase, and a number";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: verticalSpacing),
                                  CustomButton(
                                    text: state is LoginLoading
                                        ? "Logging in..."
                                        : "Sign In",
                                    onPressed: state is LoginLoading
                                        ? null
                                        : () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              final request = LoginRequest(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text,
                                              );

                                              context
                                                  .read<LoginBloc>()
                                                  .add(LoginSubmit(request));
                                            }
                                          },
                                  ),
                                  SizedBox(height: verticalSpacing / 1.5),
                                  Center(
                                    child: TextButton(
                                      onPressed: () {
                                        Get.to(ForgetPassword());
                                      },
                                      child: Text(
                                        "Forget Password?",
                                        style: TextStyle(
                                          fontSize: subtitleFontSize,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: verticalSpacing),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Don’t have an account? ",
                                          style: TextStyle(
                                            fontSize: subtitleFontSize,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(SignUpScreen());
                                          },
                                          child: Text(
                                            "Sign Up",
                                            style: TextStyle(
                                              fontSize: subtitleFontSize,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
