import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:skill_swap/presentation/forget_password/widgets/custom_auth.dart';
import 'package:skill_swap/presentation/sign/screens/sign_in_screen.dart';
import '../../../constants/colors.dart';
import '../../select_skills/select_track.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  const EmailVerificationScreen({super.key, required this.email});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isResend = false;
  int secondsRemaining = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining > 0) {
        setState(() => secondsRemaining--);
      } else {
        setState(() => isResend = true);
        t.cancel();
      }
    });
  }

  void goNextPage() {
    Get.to(SelectTrack());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: CustomAuth(
        title: "Verify Your Email",
        subTitle: "We have sent a verification link to ${widget.email}, Please check your email to continue.",
        childWidget: const SizedBox(),
        buttonText: "Skip",
        onPressed: goNextPage,
        bottomText: "00:${secondsRemaining.toString().padLeft(2, '0')}",
        bottomActionText:  '',
        onBottomTap: isResend
            ? () {
          setState(() {
            secondsRemaining = 30;
            isResend = false;
          });
          startTimer();
        }
            : () {
         Get.to(SelectTrack());
        },
      ),
    );
  }
}