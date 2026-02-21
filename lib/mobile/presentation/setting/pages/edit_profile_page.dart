import 'dart:io';

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skill_swap/shared/data/models/update_profile/update_profile.dart';
import 'package:skill_swap/shared/data/models/update_profile/update_profile_request.dart';
import 'package:skill_swap/shared/data/models/update_profile/update_skill.dart';

import '../../../../desktop/presentation/sign/screens/sign_up_screen.dart';
import '../../../../shared/bloc/delete_account_bloc/delete_account_bloc.dart';
import '../../../../shared/bloc/delete_account_bloc/delete_account_event.dart';
import '../../../../shared/bloc/delete_account_bloc/delete_account_state.dart';
import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/bloc/logout_bloc/logout_bloc.dart';
import '../../../../shared/bloc/logout_bloc/logout_event.dart';
import '../../../../shared/bloc/logout_bloc/logout_state.dart';
import '../../../../shared/bloc/update_profile_bloc/update_profile_bloc.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../../../shared/helper/local_storage.dart';
import '../../setting/pages/change_password.dart';
import '../../sign/screens/sign_in_screen.dart';
import '../../sign/widgets/custom_button.dart';

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

    final skillsList = profile.skills ?? [];
    skillsController.text = skillsList.map((e) => e.skillName).join(', ');

    selectedImage = null;
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
        context
            .read<UpdateProfileBloc>()
            .add(SubmitUpdateProfileImage(image.path));
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
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocListener<UpdateProfileBloc, UpdateProfileState>(
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

            final avatarRadius = screenWidth * 0.08;
            final fontSizeTitle = screenWidth * 0.045;
            final fontSizeHint = screenWidth * 0.035;
            final fontSizeSmall = screenWidth * 0.03;
            final spacing = screenWidth * 0.03;

            return SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Column(
                children: [
                  /// Profile Picture
                  containerWrapper(
                    context: context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle("profile_picture".tr,
                            fontSize: fontSizeTitle),
                        SizedBox(height: spacing),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: avatarRadius,
                              backgroundColor:
                                  AppPalette.primary.withValues(alpha: 0.25),
                              backgroundImage: selectedImage != null
                                  ? FileImage(selectedImage!) as ImageProvider
                                  : (profile?.userImage.secureUrl.isNotEmpty ??
                                          false)
                                      ? NetworkImage(
                                              profile!.userImage.secureUrl)
                                          as ImageProvider
                                      : null,
                              child: (selectedImage == null &&
                                      (profile?.userImage.secureUrl.isEmpty ??
                                          true))
                                  ? (isLoading
                                      ? SizedBox(
                                          width: avatarRadius * 1.2,
                                          height: avatarRadius * 1.2,
                                          child:
                                              const CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Icon(Icons.person,
                                          size: avatarRadius,
                                          color: Colors.white))
                                  : null,
                            ),
                            SizedBox(width: spacing),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    showImageSourceSheet();
                                  },
                                  icon: Icon(Icons.camera_alt,
                                      size: fontSizeTitle),
                                  label: Text("change_photo".tr,
                                      style:
                                          TextStyle(fontSize: fontSizeTitle)),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "JPG, PNG or GIF, Max size 2MB",
                                  style: TextStyle(
                                      fontSize: fontSizeSmall,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacing),

                  /// Personal Information
                  containerWrapper(
                    context: context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle("personal_information".tr,
                            fontSize: fontSizeTitle),
                        SizedBox(height: spacing / 2),
                        inputField("full_name".tr, "ex: Nada Sayed",
                            nameController, fontSizeHint,
                            isLoading: isLoading),
                        inputField("bio".tr, "Tell others about yourself...",
                            bioController, fontSizeHint,
                            maxLines: 3, isLoading: isLoading),
                        inputField("skills".tr, "Flutter, Dart...",
                            skillsController, fontSizeHint,
                            isLoading: isLoading),
                        SizedBox(height: spacing / 2),
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
                                name: nameController.text.trim().isEmpty
                                    ? null
                                    : nameController.text.trim(),
                                profile: UpdateProfile(
                                  bio: bioController.text.trim().isEmpty
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
                  SizedBox(height: spacing),

                  /// Account Actions
                  containerWrapper(
                    context: context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle("account_actions".tr,
                            fontSize: fontSizeTitle),
                        SizedBox(height: spacing / 2),
                        actionButton(
                          onPressedAction: () {
                            Get.to(ChangePasswordScreen());
                          },
                          colorButton: AppPalette.primary,
                          icon: Icons.change_circle_outlined,
                          colorIcon: Colors.white,
                          actionText: 'Change Password',
                          colorText: Colors.white,
                          fontSize: 16,
                        ),
                        SizedBox(height: spacing / 2),
                        BlocProvider(
                          create: (_) => sl<LogoutBloc>(),
                          child: Builder(builder: (context) {
                            return BlocListener<LogoutBloc, LogoutState>(
                              listener: (context, state) {
                                if (state is LogoutSuccessState) {
                                  Get.snackbar('Success', state.success);
                                  LocalStorage.clearAllTokens();
                                  Get.offAll(() => const SignInScreen());
                                } else if (state is LogoutFailureState) {
                                  Get.snackbar('Error', state.error);
                                }
                              },
                              child: actionButton(
                                onPressedAction: () =>
                                    _showLogoutConfirmation(context),
                                colorButton: Colors.white,
                                icon: Icons.logout,
                                colorIcon: Colors.red,
                                actionText: "sign_out".tr,
                                colorText: Colors.red,
                                fontSize: 16,
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: spacing / 2),
                        BlocProvider(
                          create: (_) => sl<DeleteAccountBloc>(),
                          child: BlocListener<DeleteAccountBloc,
                              DeleteAccountState>(
                            listener: (context, state) {
                              if (state is DeleteAccountSuccessState) {
                                LocalStorage.clearAllTokens();
                                Get.offAll(() => const SignUpScreen());
                              } else if (state is DeleteAccountFailureState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(state.message),
                                      backgroundColor: Colors.red),
                                );
                              }
                            },
                            child: BlocBuilder<DeleteAccountBloc,
                                DeleteAccountState>(
                              builder: (context, state) {
                                return actionButton(
                                  onPressedAction: () =>
                                      _showDeleteConfirmation(context),
                                  colorButton: Colors.red,
                                  icon: Icons.delete,
                                  colorIcon: Colors.white,
                                  actionText: "delete_account".tr,
                                  colorText: Colors.white,
                                  fontSize: fontSizeTitle,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacing),

                  /// Account Status
                  containerWrapper(
                    context: context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle("account_status".tr,
                            fontSize: fontSizeTitle),
                        SizedBox(height: spacing / 2),
                        statusRow("account_type".tr, profile?.role ?? '',
                            fontSizeTitle),
                        statusRow(
                          "member_since".tr,
                          profile != null
                              ? profile.createdAt
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0]
                              : '',
                          fontSizeTitle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ================= WIDGETS =================

  Widget containerWrapper(
      {required BuildContext context, required Widget child}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: child,
    );
  }

  Widget sectionTitle(String title, {double fontSize = 16}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge!.color)),
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

  Widget statusRow(String title, String value, double fontSize,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: TextStyle(fontSize: fontSize)),
        Text(value, style: TextStyle(fontSize: fontSize, color: valueColor)),
      ]),
    );
  }

  Widget actionButton({
    required VoidCallback onPressedAction,
    required Color colorButton,
    required IconData icon,
    required Color colorIcon,
    required String actionText,
    required Color colorText,
    required double fontSize,
  }) {
    return SizedBox(
      width: double.infinity,
      height: fontSize * 2.5,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: colorButton,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(fontSize * 0.75)),
            side: BorderSide(color: colorButton)),
        onPressed: onPressedAction,
        icon: Icon(icon, color: colorIcon, size: fontSize),
        label: Text(actionText,
            style: TextStyle(color: colorText, fontSize: fontSize)),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone."),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Cancel")),
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
      builder: (dialogContext) => AlertDialog(
        title: const Text("Log Out"),
        content:
            const Text("Are you sure you want to log out from your account?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<LogoutBloc>().add(LogoutRequested());
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
