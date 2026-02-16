import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/helper/local_storage.dart';
import '../../sign/screens/sign_in_screen.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // padding ديناميكي حسب ارتفاع الشاشة
    final verticalPadding = screenHeight * 0.02; // 2% من ارتفاع الشاشة

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
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
