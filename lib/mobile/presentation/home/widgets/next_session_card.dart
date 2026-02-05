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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Container(
        height: screenHeight * 0.11, // بدل 86
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).dividerColor,
              blurRadius: 10,
              offset: Offset(0, screenHeight * 0.005), // بدل 4
            ),
          ],
        ),
        child: Row(
          children: [
            /// Left Gradient Line
            Container(
              width: screenWidth * 0.01, // بدل 4
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
                        ? AppPalette.primary
                        : Colors.purple,
                    (isMentor
                        ? AppPalette.primary
                        : Colors.purple)
                        .withOpacity(0.3),
                  ],
                ),
              ),
            ),

            SizedBox(width: screenWidth * 0.03), // بدل 12

            /// Icon
            Container(
              width: screenWidth * 0.1, // بدل 40
              height: screenWidth * 0.1, // بدل 40
              decoration: BoxDecoration(
                color: AppPalette.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isMentor ? Icons.school : Icons.book,
                size: screenWidth * 0.055, // بدل 22
                color: AppPalette.primary,
              ),
            ),

            SizedBox(width: screenWidth * 0.04), // بدل 16

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
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          startsIn,
                          style: TextStyle(
                            fontSize: screenWidth * 0.03, // بدل 12
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04), // بدل 16
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.008), // بدل 6

                  /// Date & Call type
                  Row(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "$dateTime • $duration",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02), // بدل 8
                      Icon(
                        Icons.videocam_outlined,
                        size: screenWidth * 0.04, // بدل 16
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                      SizedBox(width: screenWidth * 0.01), // بدل 4
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Video Call",
                          style: Theme.of(context).textTheme.bodyMedium,
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