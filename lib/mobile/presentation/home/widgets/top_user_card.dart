import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../book_session/screens/profile_mentor.dart';

class TopUserCard extends StatelessWidget {
  final int id;
  final String image;
  final String name;
  final String track;
  final String hours;
  final double? widthCard;

  const TopUserCard({
    super.key,
    this.widthCard,
    required this.id,
    required this.image,
    required this.name,
    required this.track,
    required this.hours,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // اجعل الـ width responsive حسب حجم الشاشة أو القيمة اللي اتحطت
    final cardWidth = widthCard ?? screenWidth * 0.35;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.to(ProfileMentor(
          id: id,
          name: name,
          track: track,
          rate: 4.8,
          image: image,
        ));
      },
      child: Container(
        width: cardWidth,
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenWidth * 0.02),
            ClipOval(
              child: Image.asset(
                image,
                width: cardWidth * 0.25,
                height: cardWidth * 0.25,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "$track Developer",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            SizedBox(height: screenWidth * 0.01),
            Container(
              width: cardWidth * 0.35,
              height: screenWidth * 0.04,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    hours,
                    style: TextStyle(
                      fontSize: 8,
                      color: Theme.of(context).textTheme.titleSmall!.color,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
          ],
        ),
      ),
    );
  }
}