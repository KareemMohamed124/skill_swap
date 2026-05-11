import 'package:flutter/material.dart';
import 'package:skill_swap/shared/data/models/user/skill_model.dart';

import '../../../../shared/core/theme/app_palette.dart';

class MentorCard extends StatelessWidget {
  final String image;
  final String name;
  final String role;
<<<<<<< HEAD
  final num rate;
  final num hours;
  final num price;
=======
  final int rate;
  final int hours;
  final double price;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  final String track;
  final List<Skill> skills;
  final String responseTime;

  const MentorCard({
    super.key,
    required this.image,
    required this.name,
    required this.role,
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

<<<<<<< HEAD
    double r(double base, double min, double max) {
      final scale = width / 1440;
      return (base * scale).clamp(min, max);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: r(8, 6, 12)),
      padding: EdgeInsets.all(r(16, 12, 20)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADER
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: (image.startsWith("http"))
                    ? Image.network(
                        image,
                        width: r(60, 50, 80),
                        height: r(60, 50, 80),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(r),
                      )
                    : _buildPlaceholder(r),
              ),
              SizedBox(width: r(12, 8, 16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// NAME + TRACK + ROLE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "$name • $track",
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: r(8, 6, 12),
                            vertical: r(4, 3, 8),
                          ),
                          decoration: BoxDecoration(
                            color: role == "Mentor"
                                ? Colors.green.withOpacity(0.15)
                                : Colors.blue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            role,
                            style: TextStyle(
                              color:
                                  role == "Mentor" ? Colors.green : Colors.blue,
                              fontSize: r(12, 10, 14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: r(8, 6, 12)),

                    /// STATS
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: Colors.amber),
                        SizedBox(width: r(6, 4, 10)),
                        Flexible(
                          child: Text(
                            "${rate.toStringAsFixed(1)} • $hours hours • ${price == 0 ? 'Free' : '\$$price/hr'}",
                            style: Theme.of(context).textTheme.bodySmall,
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

          SizedBox(height: r(12, 10, 16)),

          /// SKILLS
          Wrap(
            spacing: r(8, 6, 12),
            runSpacing: r(8, 6, 12),
            children: skills.map((skill) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: r(10, 8, 14),
                  vertical: r(6, 4, 10),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6D6D6).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  skill.skillName,
                  style: TextStyle(
                    fontSize: r(12, 10, 14),
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
    );
  }

  Widget _buildPlaceholder(double Function(double, double, double) r) {
    return Builder(
      builder: (context) {
        return Container(
          width: r(60, 50, 80),
          height: r(60, 50, 80),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
          ),
        );
      },
    );
  }
=======
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
                              color: role == "Mentor"
                                  ? Colors.green.withOpacity(.15)
                                  : Colors.blue.withOpacity(.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              role,
                              style: TextStyle(
                                color: role == "Mentor"
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
                    skill.skillName,
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
}
