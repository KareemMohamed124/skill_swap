import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../constants/colors.dart';

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
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Container(
        height: 86,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            /// Left Gradient Line
            Container(
              width: 4,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    isMentor
                        ? AppColor.mainColor
                        : Colors.purple,
                    (isMentor
                        ? AppColor.mainColor
                        : Colors.purple)
                        .withOpacity(0.3),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.mainColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
               isMentor ? Icons.school : Icons.book,
                  size: 22,
                  color: AppColor.mainColor
              )
            ),

            const SizedBox(width: 16),

            /// Content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name + Starts in
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        startsIn,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 16,)
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// Date & Call type
                  Row(
                    children: [
                      Text(
                        "$dateTime • $duration",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.videocam_outlined,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Video Call",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
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