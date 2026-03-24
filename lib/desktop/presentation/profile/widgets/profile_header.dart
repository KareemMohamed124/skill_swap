import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
        builder: (context, state) {
      String name = "User";
      String imagePath = '';
      int freeHours = 0;
      int helpHours = 0;
      if (state is MyProfileLoaded) {
        final profile = state.profile;

        name = profile.name.isNotEmpty ? profile.name : "User";
        imagePath = profile.userImage.secureUrl;
        freeHours = profile.freeHours;
        helpHours = profile.helpTotalHours;
      }

      final hasImage = imagePath.isNotEmpty;
      return Container(
        width: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).cardColor,
                  backgroundImage: (!hasImage ||
                          defaultTargetPlatform == TargetPlatform.windows)
                      ? null
                      : NetworkImage(imagePath) as ImageProvider,
                  child: (!hasImage ||
                          defaultTargetPlatform == TargetPlatform.windows)
                      ? Icon(
                          Icons.person,
                          size: 24,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Text(name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(width: 6),
                    const Icon(Icons.star, color: Colors.yellow, size: 18),
                    const SizedBox(width: 4),
                    const Text('4.9', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
      return const SizedBox.shrink();
    });
  }
}
