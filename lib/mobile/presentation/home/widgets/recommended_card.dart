import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../book_session/screens/profile_mentor.dart';

class RecommendedCard extends StatelessWidget {
  final int id;
  final String image;
  final String name;
  final String track;
  final double rating;
  final double? width;
  final double? imageHeight;

  const RecommendedCard({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.track,
    required this.rating,
    this.width,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final cardWidth = width ?? screenWidth * 0.45;
    final cardImageHeight = imageHeight ?? cardWidth * 0.55;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.to(ProfileMentor(
          id: id,
          name: name,
          track: track,
          rate: rating,
          image: image,
        ));
      },
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        padding: EdgeInsets.all(screenWidth * 0.02), // بدل 8
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                image,
                width: double.infinity,
                height: cardImageHeight,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: screenWidth * 0.01), // بدل 4
            Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                Icon(
                  Icons.star,
                  size: screenWidth * 0.03, // بدل 12
                  color: const Color(0xFFFFCE31),
                ),
                SizedBox(width: screenWidth * 0.01), // بدل 4
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "$rating",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "$track Development",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}