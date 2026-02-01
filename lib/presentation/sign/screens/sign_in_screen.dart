import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/common_ui/screen_manager/screen_manager.dart';
import 'package:skill_swap/domain/repositories/auth_repository.dart';
import 'package:skill_swap/presentation/sign/screens/sign_up_screen.dart';
import 'package:skill_swap/presentation/sign/widgets/custom_appbar.dart';
import 'package:skill_swap/presentation/sign/widgets/custom_button.dart';
import 'package:skill_swap/presentation/sign/widgets/custom_text_field.dart';
import '../../../bloc/login_bloc/login_bloc.dart';
import '../../../bloc/login_bloc/login_event.dart';
import '../../../bloc/login_bloc/login_state.dart';
import '../../../dependency_injection/injection.dart';
import '../../../data/models/login/login_request.dart';
import '../../../helper/local_storage.dart';
import '../../forget_password/screens/forget_password_screen.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: Scaffold(
      //  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            Column(
              children: [
                const CustomAppBar(title: "Sign In"),
              ],
            ),
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: BlocConsumer<LoginBloc, LoginState>(
                      listener: (context, state) async {
                        if (state is LoginFailureState) {
                          setState(() {
                            _handleServerError(state);
                          });
                        } else if (state is LoginSuccessState) {
                          await LocalStorage.saveToken(state.data.accessToken);
                          final repo = sl<AuthRepository>();
                          final user = await repo.getProfile();
                         await LocalStorage.saveUser(user);
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(state.data.message)));
                          Get.to(ScreenManager(initialIndex: 0));
                        }
                      },
                      builder: (context, state) {
                        return Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                "Welcome Back!",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.bodyLarge!.color
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Sign in to continue your learning journey",
                                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color
                              ),
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
                                    return "Password must contain at least 8 character, uppercase, lowercase, and a number";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 32),

                              CustomButton(
                                text: state is LoginLoading ? "Logging in..." : "Sign In",
                                onPressed: state is LoginLoading
                                    ? null
                                    : () {
                                  if (formKey.currentState!.validate()) {
                                    final request = LoginRequest(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );

                                    context.read<LoginBloc>().add(LoginSubmit(request));
                                  }
                                },
                              ),

                              const SizedBox(height: 24),
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Get.to(ForgetPassword());
                                  },
                                  child:  Text(
                                    "Forget Password?",
                                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color
                                  ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don’t have an account? ",
                                      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(SignUpScreen());
                                      },
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.bodyLarge!.color
                                        ),
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
          ],
        ),
      ),
    );
  }
}