
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skill_swap/presentation/constants/colors.dart';
import 'package:skill_swap/presentation/forget_password/widgets/CustomAuth.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool isResend = false;
  int secondsRemaining = 40;
  late Timer timer;

  void startTimer() {
    timer = Timer.periodic(
        Duration(seconds: 1),
        (t) {
          setState(() {
            if(secondsRemaining > 0) {
              secondsRemaining-- ;
            } else {
              isResend = true;
              t.cancel();
            }
          });
        }
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: CustomAuth(
          title: 'Verify Your Email',
          subTitle: 'Enter the 6-digit code send to nada@gamil.com.',
          childWidget: Row(
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
                    border: Border.all(
                      color: Color(0xFFE6E7FF),
                    )
                  ),
                  child: const Text(
                    '-',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFFE6E7FF)
                    ),
                  ),
                )
            )
          ),
          buttonText: 'Verify',
          onPressed: (){},
          bottomText: isResend ? "Didn't receive the code? " : "Resend code in 00:${secondsRemaining.toString().padLeft(2, '0')}" ,
          bottomActionText: isResend ? 'Resend' : '',
          onBottomTap: isResend ? (){
            setState(() {
              isResend = false;
              secondsRemaining = 40;
            });
            startTimer();
          } : (){}
      ),
    );
  }
}
