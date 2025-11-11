import 'package:flutter/material.dart';

import '../../constants/colors.dart';
class CustomAuth extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget childWidget;
  final String buttonText;
  final VoidCallback onPressed;
  final String bottomText;
  final String bottomActionText;
  final VoidCallback onBottomTap;

  const CustomAuth({
    super.key,
    required this.title,
    required this.subTitle,
    required this.childWidget,
    required this.buttonText,
    required this.onPressed,
    required this.bottomText,
    required this.bottomActionText,
    required this.onBottomTap
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 361,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: grayColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child:  Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subTitle,
              style: TextStyle(fontSize: 16, color: mainColor),
            ),
            const SizedBox(height: 32),
            childWidget,

            const SizedBox(height: 16),
            SizedBox(
              width: 329,
              height: 50,
              child:  ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onPressed,
                child:  Text(
                  buttonText,
                  style:
                  TextStyle(fontSize: 16, color: grayColor),
                ),
              ),
            ),

            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  bottomText,
                  style: TextStyle(color: mainColor),
                ),
                GestureDetector(
                  onTap: onBottomTap,
                  child:  Text(
                    bottomActionText,
                    style: TextStyle(color: mainColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
