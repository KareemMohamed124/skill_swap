import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../book_session/screens/profile_mentor.dart';

class RecommendedCard extends StatelessWidget {
  final int id;
  final String image;
  final String name;
  final String track;
  final double rating;

  const RecommendedCard({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.track,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.to(
          ProfileMentor(
            id: id,
            name: name,
            track: track,
            rate: rating,
            image: image,
          ),
        );
      },
      child: Container(
        width: screenWidth * 0.55, // 👈 نسبة من الشاشة
        decoration: BoxDecoration(
          color: AppColor.grayColor.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.mainColor),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 9, // 👈 يحافظ على شكل الصورة
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(
                  Icons.star,
                  size: 12,
                  color: Color(0xFFFFCE31),
                ),
                const SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              "$track Development",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: AppColor.mainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}