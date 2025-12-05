import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class MentorCard extends StatelessWidget {
  final String image;
  final String name;
  final String status;
  final double rate;
  final int hours;
  final double price;
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
    required this.skills,
    required this.responseTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.mainColor),
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
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
                          rate.toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          " • $hours hours • ",
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          "\$$price/hr",
                          style: const TextStyle(fontSize: 12),
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
                  color: AppColor.grayColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.blackColor,
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