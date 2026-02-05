import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/book_session/screens/book_session.dart';
import 'package:skill_swap/main.dart';
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
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(   // 👈 دي أهم سطر
                flex: 6,  // الصورة تاخد 60% من الكارت
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Expanded(   // 👈 الجزء السفلي
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.star, size: 16, color: Color(0xFFFFCE31)),
                        const SizedBox(width: 4),
                        Text("$rating",
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    Text(
                      "$track Development",
                      style: Theme.of(context).textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
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