import 'dart:io';

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/user/user_model.dart';
import '../../../../shared/helper/local_storage.dart';
import '../../sign/screens/sign_in_screen.dart';
import '../../sign/widgets/custom_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  final bioController = TextEditingController(
      text:
          "Mobile Flutter Developer focused on fast, scalable app.\nBLoC • APIs • Clean UI");
  final skillsController = TextEditingController(text: "Flutter, Dart");

  UserModel? user;
  bool loading = true;
  File? selectedImage;

  Future<void> loadLocalUser() async {
    final localUser = await LocalStorage.getUser();
    if (mounted && localUser != null) {
      setState(() {
        user = localUser;
        nameController.text = localUser.name ?? '';
        emailController.text = localUser.email ?? '';
        loading = false;
      });
    }
  }

  /// ===================== PICK IMAGE =====================
  Future<void> pickImage(ImageSource source) async {
    if (defaultTargetPlatform == TargetPlatform.windows &&
        source == ImageSource.camera) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camera not available on Windows")),
      );
      return;
    }

    try {
      final ImagePicker picker = ImagePicker();
      final image = await picker.pickImage(source: source);
      if (image != null) {
        setState(() => selectedImage = File(image.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    }
  }

  void showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (defaultTargetPlatform != TargetPlatform.windows)
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  /// ===================== BUILD =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Picture
            containerWrapper(
              context: context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("profile_picture".tr),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppPalette.primary.withOpacity(0.25),
                        backgroundImage:
                            (defaultTargetPlatform == TargetPlatform.windows)
                                ? null
                                : (selectedImage != null
                                    ? FileImage(selectedImage!)
                                    : (user?.imagePath != null &&
                                            user!.imagePath!.isNotEmpty
                                        ? FileImage(File(user!.imagePath!))
                                        : null)),
                        child: (selectedImage == null &&
                                    (user?.imagePath == null ||
                                        user!.imagePath!.isEmpty) ||
                                defaultTargetPlatform == TargetPlatform.windows)
                            ? const Icon(Icons.person,
                                size: 30, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: showImageSourceSheet,
                            icon: const Icon(Icons.camera_alt),
                            label: Text("change_photo".tr),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "JPG, PNG or GIF, Max size 2MB",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Personal Information
            containerWrapper(
              context: context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("personal_information".tr),
                  const SizedBox(height: 8),
                  inputField("full_name".tr, "ex: Nada Sayed", nameController),
                  inputField(
                      "email".tr, "ex: example@gmail.com", emailController),
                  inputField(
                      "bio".tr, "Tell others about yourself...", bioController,
                      maxLines: 3),
                  inputField("skills".tr, "Flutter, Dart...", skillsController),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child:
                        CustomButton(text: "save_changes".tr, onPressed: () {}),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Account Actions
            containerWrapper(
              context: context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("account_actions".tr),
                  const SizedBox(height: 8),
                  actionButton(
                    onPressedAction: () {},
                    colorButton: Colors.white,
                    icon: Icons.delete,
                    colorIcon: const Color(0xFFD91515),
                    actionText: "delete_account".tr,
                    colorText: const Color(0xFFD91515),
                  ),
                  const SizedBox(height: 8),
                  actionButton(
                    onPressedAction: () {
                      Get.to(SignInScreen());
                    },
                    colorButton: const Color(0xFFD91515),
                    icon: Icons.logout,
                    colorIcon: Colors.white,
                    actionText: "sign_out".tr,
                    colorText: Colors.white,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Account Status
            containerWrapper(
              context: context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("account_status".tr),
                  statusRow("account_type".tr, "learner".tr),
                  statusRow("member_since".tr, "january_2024".tr),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===================== WIDGETS =====================
  Widget containerWrapper(
      {required BuildContext context, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: child,
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge!.color),
      ),
    );
  }

  Widget inputField(String label, String hint, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              fontSize: 12, color: AppPalette.primary.withOpacity(0.25)),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget statusRow(String title, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: TextStyle(color: valueColor),
          ),
        ],
      ),
    );
  }

  Widget actionButton({
    required VoidCallback onPressedAction,
    required Color colorButton,
    required IconData icon,
    required Color colorIcon,
    required String actionText,
    required Color colorText,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: Colors.red),
        ),
        onPressed: onPressedAction,
        icon: Icon(icon, color: colorIcon),
        label: Text(
          actionText,
          style: TextStyle(color: colorText),
        ),
      ),
    );
  }
}
