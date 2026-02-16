import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/helper/local_storage.dart';
import '../../../../mobile/presentation/sign/screens/sign_in_screen.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () async {
          await LocalStorage.clearAllTokens();
          Get.offAll(() => const SignInScreen());
        },
        icon: const Icon(Icons.logout),
        label: const Text("Sign Out"),
      ),
    );
  }
}
