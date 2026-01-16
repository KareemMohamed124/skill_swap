import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import 'package:skill_swap/presentation/book_session/screens/profile_mentor.dart';

class TopUserCard extends StatelessWidget {
  final int id;
  final String image;
  final String name;
  final String track;
  final String hours;
  final double widthCard;

  const TopUserCard({
    super.key,
    this.widthCard = 149,
    required this.id,
    required this.image,
    required this.name,
    required this.track,
    required this.hours,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.to(ProfileMentor(id: id, name: name, track: track, rate: 4.8, image: image,));
      },
      child: Container(
        width: widthCard,
        decoration: BoxDecoration(
          color: AppColor.grayColor.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.mainColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            ClipOval(
              child: Image.asset(
                image,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              "$track Developer",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 8,
                color: AppColor.mainColor,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 54,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColor.mainColor),
              ),
              child: Center(
                child: Text(
                  hours,
                  style: TextStyle(
                    fontSize: 8,
                    color: AppColor.mainColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}