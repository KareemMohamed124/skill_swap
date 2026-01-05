import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retrofit/retrofit.dart';
import 'package:skill_swap/common_ui/circle_button_icon.dart';

import '../../setting/screens/setting.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

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
                  ClipOval(
            child: Image.asset(
              'assets/images/people_images/nada.jpg',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
    ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nada Sayed',
                        style: TextStyle(
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
              //  const Icon(Icons.settings, color: Colors.white),
                CircleButtonIcon(icon: Icons.settings, onTap: (){
                  Get.to(SettingScreen());
                })
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
