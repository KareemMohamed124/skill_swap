import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/common_ui/circle_button_icon.dart';
import 'package:skill_swap/constants/colors.dart';
import '../../../data/models/user/user_model.dart';
import '../../../helper/local_storage.dart';
import '../../setting/screens/setting.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  UserModel? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final fetchedUser = await LocalStorage.getUser();
    setState(() {
      user = fetchedUser;
      loading = false;
    });
  }

  Widget _buildMetricItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xff0D035F);

    if (loading || user == null) {
      // لو لسه محملش يوزر
      return Container(
        height: 208,
        color: primaryColor,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Container(
      height: 208,
      decoration: const BoxDecoration(color: primaryColor),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 40,
              left: 16,
              right: 16,
              bottom: 20,
            ),
            child: Row(
              children: [
                // ===== CircleAvatar بدلاً من Image.asset ثابتة =====
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  backgroundImage: user!.imagePath != null && user!.imagePath!.isNotEmpty
                      ? FileImage(File(user!.imagePath!))
                      : null,
                  child: user!.imagePath == null || user!.imagePath!.isEmpty
                      ? const Icon(Icons.person, size: 30, color: AppColor.mainColor)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user!.name ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(Icons.star, color: Colors.yellow, size: 16),
                          SizedBox(width: 4),
                          Text('4.9', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
                CircleButtonIcon(
                  icon: Icons.settings,
                  onTap: () {
                    Get.to(SettingScreen());
                  },
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricItem('3', 'Hours Available'),
                _buildMetricItem('15', 'People Helped'),
                _buildMetricItem('3', 'Achievements'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}