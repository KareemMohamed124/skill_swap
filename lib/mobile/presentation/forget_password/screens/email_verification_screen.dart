import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../select_skills/select_track.dart';
import '../widgets/custom_auth.dart';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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