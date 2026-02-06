import 'package:flutter/material.dart';

import '../../../../shared/constants/strings.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../widgets/session_card.dart';

class AllSessionsPage extends StatefulWidget {
  const AllSessionsPage({super.key});

  @override
  State<AllSessionsPage> createState() => _AllSessionsPageState();
}

class _AllSessionsPageState extends State<AllSessionsPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04), // responsive padding
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Sessions",
            style: TextStyle(
              fontSize: screenWidth * 0.045, // responsive font size
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppPalette.darkTextPrimary
                  : AppPalette.lightTextPrimary,
            ),
          ),
          SizedBox(height: screenHeight * 0.01), // responsive spacing
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: AppData.allList.length,
            separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.02),
            itemBuilder: (_, index) {
              return SessionCard(session: AppData.allList[index]);
            },
          ),
          SizedBox(height: screenHeight * 0.03),
          Text(
            "Your Request",
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppPalette.darkTextPrimary
                  : AppPalette.lightTextPrimary,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: AppData.requestList.length,
            separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.02),
            itemBuilder: (_, index) {
              return SessionCard(session: AppData.requestList[index]);
            },
          ),
        ],
      ),
    );
  }
}
