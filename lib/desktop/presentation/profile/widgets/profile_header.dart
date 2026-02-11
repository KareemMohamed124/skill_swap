import 'dart:io';

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';

import '../../../../shared/data/models/user/user_model.dart';
import '../../../../shared/helper/local_storage.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  UserModel? user;

  @override
  Future<void> loadLocalUser() async {
    final localUser = await LocalStorage.getUser();
    if (mounted && localUser != null) {
      setState(() => user = localUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xff0D035F);

    final imagePath = user?.imagePath;
    final hasImage = imagePath != null && imagePath.isNotEmpty;

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
                backgroundColor: Colors.white24,
                backgroundImage: (hasImage &&
                        defaultTargetPlatform != TargetPlatform.windows)
                    ? FileImage(File(imagePath))
                    : null,
                child: (!hasImage ||
                        defaultTargetPlatform == TargetPlatform.windows)
                    ? const Icon(Icons.person, size: 24, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Text(user?.name ?? 'Kemo',
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
  }
}
