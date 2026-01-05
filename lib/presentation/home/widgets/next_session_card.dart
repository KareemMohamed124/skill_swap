import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class NextSessionCard extends StatelessWidget {
  final String image;
  final String name;
  final String duration;
  final String time;
  final double heightCard;

  const NextSessionCard({
    super.key,
    this.heightCard = 78,
    required this.image,
    required this.name,
    required this.duration,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Container(
        height: 78,
        decoration: BoxDecoration(
          color: AppColor.grayColor.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.mainColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
                image,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Text(
                        duration,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.redColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.date_range_outlined,
                        size: 16,
                        color: AppColor.mainColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          time,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColor.mainColor,
                          ),
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