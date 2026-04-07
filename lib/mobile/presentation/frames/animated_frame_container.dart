import 'package:flutter/material.dart';

import 'frame_style.dart';
import 'frame_styles_map.dart';
import 'skill_type.dart';

class AnimatedFrameContainer extends StatefulWidget {
  final Widget child;
  final SkillType skill;
  final BorderRadius borderRadius;

  const AnimatedFrameContainer({
    super.key,
    required this.child,
    required this.skill,
    required this.borderRadius,
  });

  @override
  State<AnimatedFrameContainer> createState() => _AnimatedFrameContainerState();
}

class _AnimatedFrameContainerState extends State<AnimatedFrameContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  BoxDecoration _buildDecoration(FrameStyle style) {
    return BoxDecoration(
      borderRadius: widget.borderRadius,
      gradient: SweepGradient(
        colors: style.colors,
        transform: GradientRotation(_controller.value * 6.28),
      ),
      boxShadow: [
        BoxShadow(
          color: style.glowColor.withOpacity(0.4),
          blurRadius: 10,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.skill == SkillType.none) return widget.child;

    final style = frameStyles[widget.skill]!;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Stack(
          children: [
            Container(
              decoration: _buildDecoration(style),
              padding: const EdgeInsets.all(1.5), // ✅ صغير جدًا
              child: ClipRRect(
                borderRadius: widget.borderRadius, // ✅ نفس الشكل
                child: widget.child,
              ),
            ),

            /// ✨ Badge
            Positioned(
              bottom: -6,
              right: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: style.glowColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: style.glowColor.withOpacity(0.6),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  style.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
