import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_responsive.dart';

import '../../../common_ui/circle_button_icon.dart';
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
            leading: CircleButtonIcon(icon: Icons.arrow_back_ios, onTap: () {Get.back();},)
          // IconButton(
          //   icon: const Icon(Icons.arrow_back, color: Color(0xFFF2F5F8),),
          //   onPressed: () => Navigator.pop(context),
          // ),
        ),
      ],
    );
  }
}
