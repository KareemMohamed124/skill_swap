import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../book_session/screens/profile_mentor.dart';

class TopUserCard extends StatelessWidget {
  final int id;
  final String image;
  final String name;
  final String track;
  final String hours;
  final double widthCard;

  const TopUserCard({
    super.key,
    this.widthCard = 154,
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
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
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
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              "$track Developer",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall
            ),
            const SizedBox(height: 4),
            Container(
              width: 54,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Center(
                child: Text(
                  hours,
                  style: TextStyle(
                    fontSize: 8,
                    color: Theme.of(context).textTheme.titleSmall!.color,
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