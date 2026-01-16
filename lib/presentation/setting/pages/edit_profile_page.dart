import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skill_swap/constants/colors.dart';
import 'package:skill_swap/presentation/sign/screens/sign_in_screen.dart';
import 'package:skill_swap/presentation/sign/widgets/custom_button.dart';

import '../../../data/models/user/user_model.dart';
import '../../../dependency_injection/injection.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../helper/local_storage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  UserModel? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    loadUser();
  }

  Future<void> loadUser() async {
    final fetchedUser = await LocalStorage.getUser();
    setState(() {
      user = fetchedUser;
      nameController = TextEditingController(text: user!.name ?? "");
      emailController = TextEditingController(text: user!.email ?? "");
      if(user?.imagePath != null) {
        selectedImage = File(user!.imagePath!);
      }
      loading = false;
    });
  }
  // Controllers
  final bioController = TextEditingController(text: "Mobile Flutter Developer focused on fast, scalable app.\nBLoC • APIs • Clean UI");
  final skillsController = TextEditingController(text: "Flutter, Dart");

  File? selectedImage;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    if (image != null) {
      await LocalStorage.saveUserImage(image.path);
      setState(() {
        selectedImage = File(image.path);
      });
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Profile Picture
            containerWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("Profile Picture"),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColor.mainColor.withValues(alpha: 0.25),
                        backgroundImage: selectedImage != null
                            ? FileImage(selectedImage!)
                            : (user?.imagePath != null && user!.imagePath!.isNotEmpty
                            ? FileImage(File(user!.imagePath!))
                            : null),
                        child: (selectedImage == null && (user?.imagePath == null || user!.imagePath!.isEmpty))
                            ? const Icon(Icons.person, size: 30, color: AppColor.whiteColor,)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: showImageSourceSheet,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text("Change Photo"),
                          ),
                          const SizedBox(height: 4,),
                          const Text(
                            "JPG, PNG or GIF, Max size 2MB",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Personal Information
            containerWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("Personal Information"),
                  const SizedBox(height: 8,),
                  inputField("Full Name", "ex: Nada Sayed", nameController),
                  inputField("Email", "ex: example@gmail.com", emailController),
                  inputField("Bio", "Tell others about yourself...", bioController, maxLines: 3),
                  inputField("Skills", "JavaScript, React, Python...", skillsController),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(text: "Save Changes", onPressed: (){}),
                  ),
                ],
              ),
            ),



            const SizedBox(height: 16),

            /// Subscription
            // containerWrapper(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           sectionTitle("Subscription"),
            //           OutlinedButton(
            //             onPressed: () {
            //               // Navigate to upgrade page
            //             },
            //             child: const Text("Upgrade"),
            //           )
            //         ],
            //       ),
            //       statusRow("Current Plan", "Free"),
            //       statusRow("Hours Available", "2 / 15 Days"),
            //     ],
            //   ),
            // ),

           // const SizedBox(height: 16),

            /// Account Actions
            containerWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("Account Actions"),
                  const SizedBox(height: 8),
                  actionButton(
                      onPressedAction: (){},
                      colorButton: AppColor.whiteColor,
                      icon: Icons.delete,
                      colorIcon: AppColor.redColor,
                      actionText: "Delete Account",
                      colorText: AppColor.redColor
                  ),
                  const SizedBox(height: 8),
                  actionButton(
                      onPressedAction: (){
                        LocalStorage.signOut();
                        Get.to(SignInScreen());
                        },
                      colorButton: AppColor.redColor,
                      icon: Icons.logout,
                      colorIcon: AppColor.whiteColor,
                      actionText:"Sign Out",
                      colorText:AppColor.whiteColor,
                  ),

                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Account Status
            containerWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("Account Status"),
                  statusRow("Account Type", "Learner"),
                 // statusRow("Current Plan", "Free"),
                  //statusRow("Hours Available", "2 / Week"),
                  statusRow("Member Since", "January 2024"),
                ],
              ),
            ),

            // const SizedBox(height: 20),
            //
            // /// Sign Out
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton.icon(
            //     style: ElevatedButton.styleFrom(
            //       side: BorderSide(
            //
            //       ),
            //       backgroundColor: Colors.red,
            //       padding: const EdgeInsets.symmetric(vertical: 14),
            //     ),
            //     onPressed: () {
            //       // Sign out logic
            //     },
            //     icon: const Icon(Icons.logout, color: AppColor.whiteColor,),
            //     label: const Text("Sign Out",style: TextStyle(color: AppColor.whiteColor),),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget containerWrapper({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.grayColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.mainColor),
      ),
      child: child,
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget inputField(
      String label,
      String hint,
      TextEditingController controller, {
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 12,
            color: AppColor.mainColor.withValues(alpha: 0.25)
          ),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget statusRow(
      String title,
      String value, {
        Color? valueColor,
      }) {
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
    return  SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: Colors.red
          )
        ),
        onPressed: onPressedAction,
        icon: Icon(icon, color: colorIcon),
        label: Text(actionText, style: TextStyle(color: colorText),),
      ),
    );
  }
}
