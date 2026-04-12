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

  const NextSessionCard({
    super.key,
    required this.name,
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
      widget.isMentor ? const Color(0xFF7E57C2) : AppPalette.primary;

  String get emoji => widget.isMentor ? "🧑🏻‍🏫" : "🧑🏻‍🎓";

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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSoon = remaining.inMinutes <= 60 && !remaining.isNegative;
    final canJoin = remaining.inMinutes <= 10;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: widget.onTap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),

            /// Full Background Gradient
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.isMentor
                  ? [Color(0xFF7E57C2), Color(0xFF9C7BFF)]
                  : [AppPalette.primary, AppPalette.primary.withOpacity(0.7)],
            ),

            /// Shadow
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),

              /// Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Center(
                    child: FaIcon(widget.isMentor
                        ? FontAwesomeIcons.chalkboardTeacher
                        : FontAwesomeIcons.userGraduate)),
              ),

              const SizedBox(width: 12),

              /// Content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Name + Timer + Video Call
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
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
                                ? Colors.red.withOpacity(0.3)
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            formatDuration(remaining),
                            style: TextStyle(
                              color: isSoon ? Colors.redAccent : Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Row(
                        //   children: [
                        //     Icon(Icons.videocam_rounded,
                        //         size: 16, color: Colors.white),
                        //     const SizedBox(width: 4),
                        //     Text(
                        //       "Video Call",
                        //       style: const TextStyle(
                        //         color: Colors.white,
                        //         fontWeight: FontWeight.w500,
                        //         fontSize: 12,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// Date & Duration
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 16, color: Colors.white70),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "${widget.dateTime} • ${widget.duration}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// Join Button
                    Row(
                      children: [
                        const Spacer(),
                        if (canJoin)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Text(
                              "Join Now",
                              style: TextStyle(
                                color: widget.isMentor
                                    ? const Color(0xFF7E57C2)
                                    : AppPalette.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
