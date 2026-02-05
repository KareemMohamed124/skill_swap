import 'package:flutter/material.dart';
import 'package:skill_swap/desktop/presentation/book_session/screens/book_session.dart';
import 'package:skill_swap/main.dart';

import '../../book_session/screens/profile_mentor.dart';

class TopUserCard extends StatelessWidget {
  final int id;
  final String image;
  final String name;
  final String track;
  final String hours;

  const TopUserCard({
    super.key,
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
        desktopKey.currentState?.openSidePage(
            body: ProfileMentor(
              id: id,
              name: name,
              track: track,
              rate: 4.8,
              image: image,
            ),
            rightPanel: BookSession()
        );
       // openSidePage();
       //  Get.to(ProfileMentor(
       //    id: id,
       //    name: name,
       //    track: track,
       //    rate: 4.8,
       //    image: image,
       //  ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                image,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              "$track Developer",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border:
                Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Text(
                hours,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}