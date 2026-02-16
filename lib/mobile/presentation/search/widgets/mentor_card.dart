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

    return Container(
      margin: EdgeInsets.symmetric(vertical: width * 0.025),
      padding: EdgeInsets.all(width * 0.04),
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
                  width: width * 0.13,
                  height: width * 0.13,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: width * 0.03),
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
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02,
                            vertical: width * 0.01,
                          ),
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
                              fontSize: width * 0.028,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: width * 0.015),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: Colors.amber),
                        SizedBox(width: width * 0.01),
                        Flexible(
                          child: Text(
                            "${rate.toString()} • $hours hours • \$$price/hr",
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
          SizedBox(height: width * 0.02),
          Wrap(
            spacing: width * 0.02,
            runSpacing: width * 0.02,
            children: skills.map((skill) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.025,
                  vertical: width * 0.02,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6D6D6).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    fontSize: width * 0.028,
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
}
