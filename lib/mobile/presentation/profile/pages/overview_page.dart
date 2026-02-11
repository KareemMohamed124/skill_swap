import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/core/theme/app_palette.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // نخلي maxWidth للعناصر الكبيرة زي ال Containers علشان ما يمتدش اكتر من اللازم
    double containerWidth = screenWidth < 600 ? screenWidth : 600;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: containerWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // أول Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.filter_center_focus,
                          color: isDark
                              ? AppPalette.darkTextPrimary
                              : const Color(0xFF1B1464),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "progress_to_mentor".tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "Help others (15/100 hours)",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          ),
                        ),
                        Text(
                          "15%",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 10,
                      child: LinearProgressIndicator(
                        value: 0.15,
                        color: const Color(0xFF1B1464),
                        backgroundColor: const Color(0XFFF2F5F8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "Verify skills (2/3 required)",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          ),
                        ),
                        Text(
                          "67%",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 10,
                      child: LinearProgressIndicator(
                        value: 0.67,
                        color: const Color(0xFF1B1464),
                        backgroundColor: const Color(0XFFF2F5F8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B1464),
                          padding: const EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "complete_skills_verification".tr,
                          style: const TextStyle(
                            color: Color(0XFFF2F5F8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0XFFF2F5F8),
                          padding: const EdgeInsets.all(14),
                          side: const BorderSide(
                              color: Color(0xFF1B1464), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "apply_mentor".tr,
                          style: const TextStyle(
                            color: Color(0XFF0D035F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Container الثاني
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "recent_activity".tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    activityItem(
                        context, "Completed React assessment", "2 days ago"),
                    activityItem(
                        context, "Helped Sarah with JavaScript", "3 days ago"),
                    activityItem(
                        context, "Joined React community chat", "1 week ago"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget activityItem(BuildContext context, String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 10,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
        ],
      ),
    );
  }
}
