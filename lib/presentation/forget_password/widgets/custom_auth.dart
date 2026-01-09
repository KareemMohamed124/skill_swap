import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class CustomAuth extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget childWidget;
  final String buttonText;
  final VoidCallback? onPressed;
  final String bottomText;
  final String bottomActionText;
  final VoidCallback? onBottomTap;

  const CustomAuth({
    super.key,
    required this.title,
    required this.subTitle,
    required this.childWidget,
    required this.buttonText,
    required this.onPressed,
    required this.bottomText,
    required this.bottomActionText,
    required this.onBottomTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isChildSizedBox = childWidget is SizedBox;

    return Center(
      child: Container(
        width: 361,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.grayColor.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.mainColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subTitle,
              style: TextStyle(fontSize: 16, color: AppColor.mainColor),
            ),
            const SizedBox(height: 32),
            childWidget,
            if (!isChildSizedBox) const SizedBox(height: 16),

            SizedBox(
              width: 329,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onPressed,
                child: Text(
                  buttonText,
                  style: TextStyle(fontSize: 16, color: AppColor.whiteColor),
                ),
              ),
            ),

            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(bottomText, style: TextStyle(color: Color(0xff142057))),
                GestureDetector(
                  onTap: onBottomTap,
                  child: Text(
                    bottomActionText,
                    style: TextStyle(color: AppColor.mainColor),
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