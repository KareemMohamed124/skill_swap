import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/core/theme/app_palette.dart';

class ProfileMentorHeader extends StatelessWidget {
  final String image;
  final String name;
  final String track;
  final double rate;

  const ProfileMentorHeader({
    super.key,
    required this.image,
    required this.name,
    required this.track,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final containerHeight = screenHeight * 0.2; // ارتفاع نسبي
    final imageSize = screenWidth * 0.12; // حجم الصورة نسبي
    final nameFontSize = screenWidth * 0.05; // حجم الخط لاسم
    final trackFontSize = screenWidth * 0.045;
    final rateFontSize = screenWidth * 0.04;
    final iconSize = screenWidth * 0.04;

    return Container(
      height: containerHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppPalette.primary,
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, size: iconSize, color: Colors.white),
              onPressed: () {
                Get.back();
              },
            ),
            SizedBox(width: screenWidth * 0.01),
            ClipOval(
              child: Image.asset(
                image,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style:
                        TextStyle(fontSize: nameFontSize, color: Colors.white),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "$track Developer • ",
                        style: TextStyle(
                            fontSize: trackFontSize, color: Colors.white70),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star,
                              size: iconSize, color: const Color(0xFFFFCE31)),
                          SizedBox(width: screenWidth * 0.01),
                          Text(
                            "$rate",
                            style: TextStyle(
                                fontSize: rateFontSize, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
