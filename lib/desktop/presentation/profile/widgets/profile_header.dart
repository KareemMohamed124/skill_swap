import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../shared/data/models/user/user_model.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../../../shared/domain/repositories/auth_repository.dart';
import '../../../../shared/helper/local_storage.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final localUser = await LocalStorage.getUser();

    if (mounted && localUser != null) {
      setState(() => user = localUser);
    }

    try {
      final repo = sl<AuthRepository>();
      final freshUser = await repo.getProfile();
      await LocalStorage.saveUser(freshUser);

      if (mounted) setState(() => user = freshUser);
    } catch (_) {}
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
                backgroundImage: (hasImage && defaultTargetPlatform != TargetPlatform.windows)
                    ? FileImage(File(imagePath))
                    : null,
                child: (!hasImage || defaultTargetPlatform == TargetPlatform.windows)
                    ? Icon(Icons.person, size: 24, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),
              Row(
                children:[
                  Text(user?.name ?? 'Kemo',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(width: 6),
                  Icon(Icons.star, color: Colors.yellow, size: 18),
                  SizedBox(width: 4),
                  Text('4.9', style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}