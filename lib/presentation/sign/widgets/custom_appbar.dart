import 'package:flutter/material.dart';

import '../../../constants/colors.dart';



class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 124,
          decoration:  BoxDecoration(color: AppColor.mainColor),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            title,
            style:  TextStyle(
              color: AppColor.grayColor,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFF2F5F8),),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}
