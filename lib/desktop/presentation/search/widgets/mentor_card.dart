import 'package:flutter/material.dart';
import '../../../../shared/core/theme/app_palette.dart';

class MentorCard extends StatelessWidget {
  final String image;
  final String name;
  final String status;
  final double rate;
  final int hours;
  final double price;
  final String track;
  final List<String> skills;
  final String responseTime;

  const MentorCard({
    super.key,
    required this.image,
    required this.name,
    required this.status,
    required this.rate,
    required this.hours,
    required this.price,
    required this.track,
    required this.skills,
    required this.responseTime,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.asset(
                    image,
                    width: 64, // أقل من قبل
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: status == "Available"
                                  ? Colors.green.withOpacity(.15)
                                  : Colors.blue.withOpacity(.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: status == "Available"
                                    ? Colors.green
                                    : Colors.blue,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              "$rate • $hours hours • \$$price/hr",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8, // أصغر
              runSpacing: 8, // أصغر
              children: skills.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4), // أصغر
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6D6D6).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      fontSize: 11, // أصغر
                      color: isDark
                          ? AppPalette.darkTextSecondary
                          : AppPalette.lightTextSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
