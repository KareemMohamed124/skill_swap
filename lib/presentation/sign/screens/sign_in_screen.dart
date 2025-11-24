import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/presentation/sign/widgets/custom_appbar.dart';
import 'package:skill_swap/presentation/sign/widgets/custom_button.dart';
import 'package:skill_swap/presentation/sign/widgets/custom_text_field.dart';
import '../../../bloc/login_bloc/login_bloc.dart';
import '../../../bloc/login_bloc/login_event.dart';
import '../../../bloc/login_bloc/login_state.dart';
import '../../../constants/colors.dart';
import '../../../dependency_injection/injection.dart';
import '../../../data/models/login/login_request.dart';
import '../../forget_password/screens/forget_password_screen.dart';
import 'sign_up_screen.dart';

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
    final appBar = const CustomAppBar(title: "Sign In");
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
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
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginFailureState) {
                    setState(() {
                      _handleServerError(state);
                    });
                  } else if (state is LoginSuccessState) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.data.message)));
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          "Welcome Back!",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Sign in to continue your learning journey",
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 32),

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
                        const SizedBox(height: 16),

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
                              return "Password must contain uppercase, lowercase, and a number";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 32),

                        CustomButton(
                          text:
                              state is LoginLoading
                                  ? "Logging in..."
                                  : "Sign In",
                          onPressed:
                              state is LoginLoading
                                  ? null
                                  : () {
                                    if (formKey.currentState!.validate()) {
                                      final request = LoginRequest(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );

                                      context.read<LoginBloc>().add(
                                        LoginSubmit(request),
                                      );
                                    }
                                  },
                        ),

                        const SizedBox(height: 24),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ForgetPassword(),
                                ),
                              );
                            },
                            child: const Text(
                              "Forget Password?",
                              style: TextStyle(color: AppColor.mainColor),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don’t have an account? ",
                                style: TextStyle(color: AppColor.mainColor),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SignUpScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(color: AppColor.mainColor),
                                ),
                              ),
                            ],
                          ),
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
