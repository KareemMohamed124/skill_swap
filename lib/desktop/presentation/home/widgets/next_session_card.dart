import 'package:flutter/material.dart';
import '../../../../shared/core/theme/app_palette.dart';

class NextSessionCard extends StatelessWidget {
  final String name;
  final String startsIn;
  final String dateTime;
  final String duration;
  final bool isMentor;

  const NextSessionCard({
    super.key,
    required this.name,
    required this.startsIn,
    required this.dateTime,
    required this.duration,
    this.isMentor = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            decoration: BoxDecoration(
              borderRadius:
              const BorderRadius.horizontal(left: Radius.circular(16)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppPalette.primary,
                  AppPalette.primary.withOpacity(0.3),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 22,
            backgroundColor: AppPalette.primary.withOpacity(0.1),
            child: Icon(
              isMentor ? Icons.school : Icons.book,
              color: AppPalette.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style:
                        Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      startsIn,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "$dateTime • $duration",
                      style:
                      Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.videocam_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "Video Call",
                      style:
                      Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}