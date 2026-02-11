import 'dart:io';

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/common_ui/circle_button_icon.dart';
import '../../../../shared/data/models/user/user_model.dart';
import '../../../../shared/helper/local_storage.dart';
import '../../setting/screens/setting.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  UserModel? user;

  Future<void> loadLocalUser() async {
    final localUser = await LocalStorage.getUser();
    if (mounted && localUser != null) {
      setState(() => user = localUser);
    }
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
    final screenWidth = MediaQuery.of(context).size.width;
    double maxWidth = screenWidth < 600 ? screenWidth : 600;

    final imagePath = user?.imagePath;
    final hasImage = imagePath != null && imagePath.isNotEmpty;

    return Container(
      height: 208,
      width: double.infinity,
      color: primaryColor,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
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
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).cardColor,
                      backgroundImage:
                          (defaultTargetPlatform == TargetPlatform.windows)
                              ? null
                              : (hasImage ? FileImage(File(imagePath)) : null),
                      child: (!hasImage ||
                              defaultTargetPlatform == TargetPlatform.windows)
                          ? Icon(
                              Icons.person,
                              size: 30,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Kemo',
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
                              Text('4.9',
                                  style: TextStyle(color: Colors.white)),
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
                    _buildMetricItem('3', 'hours_available'.tr),
                    _buildMetricItem('15', 'people_helped'.tr),
                    _buildMetricItem('3', 'achievements'.tr),
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
