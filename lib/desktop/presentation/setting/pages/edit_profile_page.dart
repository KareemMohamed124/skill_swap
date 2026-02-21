import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skill_swap/desktop/presentation/setting/pages/change_password.dart';
import 'package:skill_swap/desktop/presentation/sign/widgets/custom_button.dart';

import '../../../../mobile/presentation/sign/screens/sign_in_screen.dart';
import '../../../../shared/bloc/delete_account_bloc/delete_account_bloc.dart';
import '../../../../shared/bloc/delete_account_bloc/delete_account_event.dart';
import '../../../../shared/bloc/delete_account_bloc/delete_account_state.dart';
import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/bloc/logout_bloc/logout_bloc.dart';
import '../../../../shared/bloc/logout_bloc/logout_event.dart';
import '../../../../shared/bloc/logout_bloc/logout_state.dart';
import '../../../../shared/bloc/update_profile_bloc/update_profile_bloc.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/update_profile/update_profile.dart';
import '../../../../shared/data/models/update_profile/update_profile_request.dart';
import '../../../../shared/data/models/update_profile/update_skill.dart';
import '../../../../shared/dependency_injection/injection.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  late TextEditingController skillsController;

  File? selectedImage;
  bool controllersFilled = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    bioController = TextEditingController();
    skillsController = TextEditingController();

    context.read<MyProfileCubit>().fetchMyProfile();
  }

  void fillControllersFromProfile(profile) {
    nameController.text = profile.name;
    bioController.text = profile.profile.bio;

    // تحويل List<UpdateSkill> لنص للعرض
    final skillsList = profile.skills ?? [];
    skillsController.text = skillsList.map((e) => e.skillName).join(', ');

    if (profile.userImage.secureUrl.isNotEmpty) {
      selectedImage = File(profile.userImage.secureUrl);
    }

    controllersFilled = true;
  }


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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return BlocListener<UpdateProfileBloc, UpdateProfileState>(
      listener: (context, state) {
        if (state is UpdateProfileSuccessState) {
          Get.snackbar('Success', state.success);
          context.read<MyProfileCubit>().fetchMyProfile();
          controllersFilled = false;
        } else if (state is UpdateProfileErrorState) {
          Get.snackbar('Error', state.error);
        }
      },
      child: BlocBuilder<MyProfileCubit, MyProfileState>(
        builder: (context, state) {
          final isLoading = state is MyProfileLoading;
          final profile = state is MyProfileLoaded ? state.profile : null;

          if (!controllersFilled && profile != null) {
            fillControllersFromProfile(profile);
          }

          final fontSizeHint = screenWidth * 0.035;

          return SingleChildScrollView(
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
                            backgroundColor:
                            AppPalette.primary.withValues(alpha: 0.25),
                            backgroundImage: selectedImage != null
                                ? FileImage(selectedImage!)
                                : null,
                            child: (selectedImage == null &&
                                (profile?.userImage.secureUrl.isEmpty ??
                                    true))
                                ? (isLoading
                                ? SizedBox(
                              width: 30,
                              height: 30,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                                : Icon(Icons.person,
                                size: 30, color: Colors.white))
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
                                style:
                                TextStyle(fontSize: 12, color: Colors.grey),
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
                      inputField("full_name".tr, "ex: Nada Sayed",
                          nameController, fontSizeHint,
                          isLoading: isLoading),
                      inputField("bio".tr, "Tell others about yourself...",
                          bioController, fontSizeHint,
                          maxLines: 3, isLoading: isLoading),
                      inputField("skills".tr, "Flutter, Dart...",
                          skillsController, fontSizeHint,
                          isLoading: isLoading),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: "save_changes".tr,
                          onPressed: () {
                            // تحويل النص لـ List<UpdateSkill>
                            final skillsList = skillsController.text
                                .split(',')
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty)
                                .map((skillName) =>
                                UpdateSkill(skillName: skillName))
                                .toList();

                            final updateRequest = UpdateProfileRequest(
                              name: nameController.text
                                  .trim()
                                  .isEmpty
                                  ? null
                                  : nameController.text.trim(),
                              profile: UpdateProfile(
                                bio: bioController.text
                                    .trim()
                                    .isEmpty
                                    ? null
                                    : bioController.text.trim(),
                              ),
                              skills: skillsList.isEmpty ? null : skillsList,
                            );

                            context
                                .read<UpdateProfileBloc>()
                                .add(SubmitUpdateProfile(updateRequest));
                          },
                        ),
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
                      SizedBox(height: 8),
                      actionButton(
                        onPressedAction: () {
                          Get.to(ChangePasswordScreen());
                        },
                        colorButton: AppPalette.primary,
                        icon: Icons.change_circle_outlined,
                        colorIcon: Colors.white,
                        actionText: 'Change Password',
                        colorText: Colors.white,
                      ),
                      SizedBox(height: 8),
                      BlocProvider(
                        create: (_) => sl<LogoutBloc>(),
                        child: Builder(builder: (context) {
                          return BlocListener<LogoutBloc, LogoutState>(
                            listener: (context, state) {
                              if (state is LogoutSuccessState) {
                                Get.snackbar('Success', state.success);
                                Get.offAll(() => const SignInScreen());
                              } else if (state is LogoutFailureState) {
                                Get.snackbar('Error', state.error);
                              }
                            },
                            child: actionButton(
                              onPressedAction: () {
                                _showLogoutConfirmation(context);
                              },
                              colorButton: Colors.white,
                              icon: Icons.logout,
                              colorIcon: Colors.red,
                              actionText: "sign_out".tr,
                              colorText: Colors.red,
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 8),
                      BlocProvider(
                        create: (_) => sl<DeleteAccountBloc>(),
                        child:
                        BlocListener<DeleteAccountBloc, DeleteAccountState>(
                          listener: (context, state) {
                            if (state is DeleteAccountSuccessState) {
                              Get.offAll(() => const SignInScreen());
                            } else if (state is DeleteAccountFailureState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: BlocBuilder<DeleteAccountBloc,
                              DeleteAccountState>(
                            builder: (context, state) {
                              return actionButton(
                                onPressedAction: () {
                                  _showDeleteConfirmation(context);
                                },
                                colorButton: Colors.red,
                                icon: Icons.delete,
                                colorIcon: Colors.white,
                                actionText: "delete_account".tr,
                                colorText: Colors.white,
                              );
                            },
                          ),
                        ),
                      )
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
                        sectionTitle(
                          "account_status".tr,
                        ),
                        statusRow(
                          "account_type".tr,
                          profile?.role ?? '',
                        ),
                        statusRow(
                          "member_since".tr,
                          profile != null
                              ? profile.createdAt
                              .toLocal()
                              .toString()
                              .split(' ')[0]
                              : '',
                        ),
                      ],
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) =>
          AlertDialog(
            title: const Text("Delete Account"),
            content: const Text(
              "Are you sure you want to delete your account? This action cannot be undone.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  context.read<DeleteAccountBloc>().add(DeleteAccountSubmit());
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) =>
          AlertDialog(
            title: const Text("Log Out"),
            content: const Text(
              "Are you sure you want to log out from your account?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  context.read<LogoutBloc>().add(LogoutRequested());
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text("Log Out"),
              ),
            ],
          ),
    );
  }

  Widget containerWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme
            .of(context)
            .dividerColor),
      ),
      child: child,
    );
  }

  Widget inputField(String label, String hint, TextEditingController controller,
      double fontSize,
      {int maxLines = 1, bool isLoading = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        enabled: !isLoading,
        decoration: InputDecoration(
          hintText: isLoading ? '' : hint,
          hintStyle: TextStyle(
              fontSize: fontSize, color: AppPalette.primary.withOpacity(0.25)),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
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
            color: Theme
                .of(context)
                .textTheme
                .bodyLarge!
                .color),
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
