<<<<<<< HEAD
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../shared/core/theme/app_palette.dart';

class NextSessionCard extends StatefulWidget {
  final String name;
  final DateTime sessionTime;
  final String dateTime;
  final String duration;
  final bool isMentor;
  final VoidCallback? onTap;
=======
import 'package:flutter/material.dart';

import '../../../../shared/core/theme/app_palette.dart';

class NextSessionCard extends StatelessWidget {
  final String name;
  final String startsIn;
  final String dateTime;
  final String duration;
  final bool isMentor;
  final int remainingMinutes;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  const NextSessionCard({
    super.key,
    required this.name,
<<<<<<< HEAD
    required this.sessionTime,
    required this.dateTime,
    required this.duration,
    this.isMentor = true,
    this.onTap,
  });

  @override
  State<NextSessionCard> createState() => _NextSessionCardState();
}

class _NextSessionCardState extends State<NextSessionCard> {
  late Duration remaining;
  late StreamSubscription ticker;

  Color get baseColor =>
      widget.isMentor ? const Color(0xFF33B1D2) : AppPalette.primary;

  @override
  void initState() {
    super.initState();
    _updateTime();
    ticker = Stream.periodic(const Duration(seconds: 1)).listen((_) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      remaining = widget.sessionTime.difference(now);
    });
  }

  String formatDuration(Duration d) {
    if (d.isNegative) return "Started";

    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;

    if (hours > 0) return "${hours}h ${minutes}m ${seconds}s";
    return "${minutes}m ${seconds}s";
  }

  @override
  void dispose() {
    ticker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSoon = remaining.inMinutes <= 60 && !remaining.isNegative;
    final canJoin = remaining.inMinutes <= 10;

    final bg = Theme.of(context).colorScheme.surface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: widget.onTap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: bg,
            border: Border.all(
              color: baseColor.withOpacity(0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              /// 🔥 Colored Side Bar
              Container(
                width: 6,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      baseColor,
                      baseColor.withOpacity(0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseColor.withOpacity(0.15),
                ),
                child: Center(
                  child: FaIcon(
                    widget.isMentor
                        ? FontAwesomeIcons.userGraduate
                        : FontAwesomeIcons.chalkboardTeacher,
                    color: baseColor,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// Content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Name + Timer
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isSoon
                                ? Colors.red.withOpacity(0.15)
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            formatDuration(remaining),
                            style: TextStyle(
                              color: isSoon ? Colors.redAccent : Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// Date & Duration
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "${widget.dateTime} • ${widget.duration}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ],
          ),
=======
    required this.startsIn,
    required this.dateTime,
    required this.duration,
    required this.remainingMinutes,
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
                    isMentor ? AppPalette.primary : Colors.purple,
                    (isMentor ? AppPalette.primary : Colors.purple)
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
                            color: remainingMinutes < 60
                                ? Colors.red
                                : AppPalette.primary,
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        ),
      ),
    );
  }
}
