import 'package:flutter/material.dart';
import 'package:skill_swap/presentation/constants/colors.dart';

class SocialButton extends StatelessWidget {
  final String text;
  const SocialButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: AppColor.grayColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
