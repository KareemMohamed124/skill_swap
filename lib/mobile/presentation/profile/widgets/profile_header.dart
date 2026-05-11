import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/common_ui/circle_button_icon.dart';
import '../../../../shared/core/theme/app_palette.dart';
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
    const Color primaryColor = Colors.blue;
<<<<<<< HEAD
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
=======
    final screenWidth = MediaQuery.of(context).size.width;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    double maxWidth = screenWidth < 600 ? screenWidth : 600;

    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, state) {
        String name = "User";
        String imagePath = '';
<<<<<<< HEAD
        num freeHours = 0;
        num helpHours = 0;
        num rate = 0.0;
=======
        int freeHours = 0;
        int helpHours = 0;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

        if (state is MyProfileLoaded) {
          final profile = state.profile;

          name = profile.name.isNotEmpty ? profile.name : "User";
          imagePath = profile.userImage.secureUrl;
<<<<<<< HEAD
          rate = profile.rate ?? 0;
          freeHours = profile.freeHours ?? 0;
          helpHours = profile.helpTotalHours ?? 0;
=======
          freeHours = profile.freeHours;
          helpHours = profile.helpTotalHours;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        }

        final hasImage = imagePath.isNotEmpty;

        return Container(
          height: 208,
          width: double.infinity,
          color: AppPalette.primary,
          child: Center(
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
                        backgroundColor: Colors.white,
                        backgroundImage:
<<<<<<< HEAD
                        hasImage ? NetworkImage(imagePath) : null,
                        child: !hasImage
                            ? const Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.grey,
                        )
=======
                            hasImage ? NetworkImage(imagePath) : null,
                        child: !hasImage
                            ? const Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.grey,
                              )
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
<<<<<<< HEAD
                            Row(
=======
                            const Row(
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                              children: [
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 16),
                                SizedBox(width: 4),
<<<<<<< HEAD
                                Text(rate.toStringAsFixed(1),
=======
                                Text('4.9',
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      CircleButtonIcon(
                        icon: Icons.settings,
                        onTap: () {
                          Get.to(() => const SettingScreen());
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
                      _buildMetricItem(
                          freeHours.toString(), 'hours_available'.tr),
                      _buildMetricItem(
                          helpHours.toString(), 'people_helped'.tr),
<<<<<<< HEAD
                      //    _buildMetricItem('3', 'achievements'.tr),
=======
                      _buildMetricItem('3', 'achievements'.tr),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
