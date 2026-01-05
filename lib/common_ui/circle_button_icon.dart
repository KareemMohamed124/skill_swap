import 'package:flutter/material.dart';

import '../constants/colors.dart';

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
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            widget.icon,
            size: 16,
            color: AppColor.mainColor,
          ),
        ),
      ),
    );
  }
}
