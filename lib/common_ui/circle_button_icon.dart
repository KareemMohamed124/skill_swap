import 'package:flutter/material.dart';

class CircleButtonIcon extends StatefulWidget {
  final  IconData icon;
  final VoidCallback? onTap;
  const CircleButtonIcon({super.key, required this.icon, this.onTap});

  @override
  State<CircleButtonIcon> createState() => _CircleButtonIconState();
}

class _CircleButtonIconState extends State<CircleButtonIcon> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Theme.of(context).cardColor,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Icon(
              widget.icon,
              size: 18,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ),
      ),
    );
  }
}
