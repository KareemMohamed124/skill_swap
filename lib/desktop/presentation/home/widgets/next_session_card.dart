import 'dart:async';

import 'package:flutter/material.dart';

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
      widget.isMentor ? AppPalette.primary : Colors.deepPurple;

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

    if (hours > 0) {
      return "in ${hours}h ${minutes}m";
    } else if (minutes > 0) {
      return "in ${minutes}m ${seconds}s";
    } else {
      return "in ${seconds}s";
    }
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: widget.onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                baseColor.withOpacity(0.08),
                Theme.of(context).cardColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                /// Emoji Avatar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: baseColor.withOpacity(0.15),
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Name + Countdown
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),

                          /// Countdown Badge
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSoon
                                  ? Colors.red.withOpacity(0.1)
                                  : baseColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              formatDuration(remaining),
                              style: TextStyle(
                                fontSize: 12,
                                color: isSoon ? Colors.red : baseColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      /// Date & Duration
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "${widget.dateTime} • ${widget.duration}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      /// Call Type + Join
                      Row(
                        children: [
                          Icon(Icons.videocam_rounded,
                              size: 16, color: baseColor),
                          const SizedBox(width: 4),
                          Text(
                            "Video Call",
                            style: TextStyle(
                              color: baseColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const Spacer(),

                          /// Join Button يظهر أوتوماتيك
                          if (canJoin)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: baseColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "Join",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
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
      ),
    );
  }
}
