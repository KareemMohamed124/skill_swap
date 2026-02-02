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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
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
                  width: 50,
                  height: 50,
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
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
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

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 18, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                         "${rate.toString()} • $hours hours • \$$price/hr",
                            style: Theme.of(context).textTheme.bodySmall
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) {
              return Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFD6D6D6).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppPalette.darkTextSecondary : AppPalette.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),

          // const SizedBox(height: 8),
          //
          // Text(
          //   "Usually responds in $responseTime",
          //   style: TextStyle(
          //     color: AppColor.mainColor,
          //     fontSize: 12,
          //   ),
          // ),
        ],
      ),
    );
  }
}