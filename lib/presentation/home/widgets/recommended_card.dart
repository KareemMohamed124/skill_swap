import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../book_session/screens/profile_mentor.dart';

class RecommendedCard extends StatelessWidget {
  final int id;
  final String image;
  final String name;
  final String track;
  final double rating;
  final double width;
  final double imageHeight;

  const RecommendedCard({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.track,
    required this.rating,
    this.width = 200,
    this.imageHeight = 116,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.to(ProfileMentor(id: id, name: name, track: track, rate: rating, image: image,));
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                image,
                width: double.infinity,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const Icon(Icons.star, size: 12, color: Color(0xFFFFCE31)),
                const SizedBox(width: 4),
                Text(
                  "$rating",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            //const SizedBox(height: 4),
            Text(
              "$track Development",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall
            ),
          ],
        ),
      ),
    );
  }
}