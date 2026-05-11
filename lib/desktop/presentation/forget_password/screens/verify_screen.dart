import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/forget_password/screens/reset_password_screen.dart';
<<<<<<< HEAD
import 'package:skill_swap/desktop/presentation/sign/widgets/custom_button.dart';
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

import '../../../../shared/bloc/send_code_bloc/send_code_bloc.dart';
import '../../../../shared/bloc/verify_code_bloc/verify_code_bloc.dart';
import '../../../../shared/dependency_injection/injection.dart';
<<<<<<< HEAD

class VerifyDesktop extends StatefulWidget {
  final String email;

  const VerifyDesktop({super.key, required this.email});

  @override
  State<VerifyDesktop> createState() => _VerifyDesktopState();
}

class _VerifyDesktopState extends State<VerifyDesktop> {
=======
import '../widgets/custom_auth.dart';

class VerifyScreen extends StatefulWidget {
  final String email;

  const VerifyScreen({super.key, required this.email});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  bool isResend = false;
  int secondsRemaining = 900;
  late Timer timer;
  String? codeError;

  List<String> codeDigits = List.filled(6, "");
  List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void startTimer() {
<<<<<<< HEAD
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
=======
    timer = Timer.periodic(Duration(seconds: 1), (t) {
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          isResend = true;
          t.cancel();
        }
      });
    });
  }

  String get timerText {
    final minutes = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
<<<<<<< HEAD
        BlocProvider(create: (_) => sl<VerifyCodeBloc>()),
        BlocProvider(create: (_) => sl<SendCodeBloc>()),
      ],
      child: Scaffold(
=======
        BlocProvider(
          create: (context) => sl<VerifyCodeBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<SendCodeBloc>(),
        )
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        body: BlocConsumer<VerifyCodeBloc, VerifyCodeState>(
          listener: (context, state) {
            if (state is VerifyCodeFailureState) {
              setState(() {
                codeError = state.error.message;
              });
            } else if (state is VerifyCodeSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.response.message)),
              );

              final code = codeDigits.join();
<<<<<<< HEAD

              Get.to(
                ResetPasswordDesktop(
                  email: widget.email,
                  code: code,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is VerifyCodeLoading;

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Verify Your Email",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Enter the 6-digit code sent to ${widget.email}.",
                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 32),

                      /// OTP Fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (index) => Container(
                            width: 45,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            child: TextField(
                              focusNode: focusNodes[index],
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  codeDigits[index] = value;

                                  if (index < 5) {
                                    FocusScope.of(context).requestFocus(
                                      focusNodes[index + 1],
                                    );
                                  } else {
                                    FocusScope.of(context).unfocus();
                                  }
                                } else {
                                  codeDigits[index] = "";

                                  if (index > 0) {
                                    FocusScope.of(context).requestFocus(
                                      focusNodes[index - 1],
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      if (codeError != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          codeError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],

                      const SizedBox(height: 32),

                      /// Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: isLoading ? "Verifying..." : "Verify",
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (codeDigits.any((d) => d.isEmpty)) {
                                    setState(() {
                                      codeError = "Please enter all 6 digits";
                                    });
                                    return;
                                  }

                                  final code = codeDigits.join();

                                  context.read<VerifyCodeBloc>().add(
                                        SubmitVerify(widget.email, code),
                                      );
                                },
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Bottom
                      Center(
                        child: GestureDetector(
                          onTap: isResend
                              ? () {
                                  setState(() {
                                    isResend = false;
                                    secondsRemaining = 900;
                                  });
                                  startTimer();
                                  context
                                      .read<SendCodeBloc>()
                                      .add(ResendCode(widget.email));
                                }
                              : null,
                          child: Text(
                            isResend
                                ? "Didn't receive the code? Resend"
                                : "Resend code in $timerText",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: isResend ? Colors.blue : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
=======
              Get.to(ResetPasswordScreen(
                email: widget.email,
                code: code,
              ));
            }
          },
          builder: (context, state) {
            return CustomAuth(
              title: 'Verify Your Email',
              subTitle: 'Enter the 6-digit code sent to ${widget.email}.',
              childWidget: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => Container(
                        width: 45,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Color(0xFFE6E7FF)),
                        ),
                        child: TextField(
                          focusNode: focusNodes[index],
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              codeDigits[index] = value;

                              if (index < 5) {
                                FocusScope.of(context)
                                    .requestFocus(focusNodes[index + 1]);
                              } else {
                                FocusScope.of(context).unfocus();
                              }
                            } else {
                              codeDigits[index] = "";

                              if (index > 0) {
                                FocusScope.of(context)
                                    .requestFocus(focusNodes[index - 1]);
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  if (codeError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        codeError!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                ],
              ),
              buttonText:
                  state is VerifyCodeLoading ? 'Verification' : 'Verify',
              onPressed: state is VerifyCodeLoading
                  ? null
                  : () {
                      if (codeDigits.any((digit) => digit.isEmpty)) {
                        setState(() {
                          codeError = "Please enter all 6 digits";
                        });
                        return;
                      }

                      final code = codeDigits.join();

                      context.read<VerifyCodeBloc>().add(
                            SubmitVerify(
                              widget.email,
                              code,
                            ),
                          );
                    },
              bottomText: isResend
                  ? "Didn't receive the code? "
                  : "Resend code in ${timerText}",
              bottomActionText: isResend ? 'Resend' : '',
              onBottomTap: isResend
                  ? () {
                      setState(() {
                        isResend = false;
                        secondsRemaining = 900; // 15 دقيقة
                      });
                      startTimer();
                      context
                          .read<SendCodeBloc>()
                          .add(ResendCode(widget.email));
                    }
                  : () {},
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            );
          },
        ),
      ),
    );
  }
}
