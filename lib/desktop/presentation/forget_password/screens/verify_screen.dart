import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/forget_password/screens/reset_password_screen.dart';

import '../../../../shared/bloc/send_code_bloc/send_code_bloc.dart';
import '../../../../shared/bloc/verify_code_bloc/verify_code_bloc.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../widgets/custom_auth.dart';

class VerifyScreen extends StatefulWidget {
  final String email;
  const VerifyScreen({super.key, required this.email});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool isResend = false;
  int secondsRemaining = 40;
  late Timer timer;
  String? codeError;

  List<String> codeDigits = List.filled(6, "");
  List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
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

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<VerifyCodeBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<SendCodeBloc>(),
        )
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              Get.to(ResetPasswordScreen(
                email: widget.email,
                code: code,
              ));
            }
          },
          builder: (context, state) {
            return CustomAuth(
              title: 'Verify Your Email',
              subTitle: 'Enter the 6-digit code send to ${widget.email}.',
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
                  return ;
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
                  : "Resend code in 00:${secondsRemaining.toString().padLeft(2, '0')}",
              bottomActionText: isResend ? 'Resend' : '',
              onBottomTap: isResend
                  ? () {
                setState(() {
                  isResend = false;
                  secondsRemaining = 40;
                });
                startTimer();
                context.read<SendCodeBloc>().add(ResendCode(widget.email));
              }
                  : () {},
            );
          },
        ),
      ),
    );
  }
}