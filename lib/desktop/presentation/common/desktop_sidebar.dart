import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/common/unreal_card.dart';
<<<<<<< HEAD
import 'package:skill_swap/desktop/presentation/setting/pages/change_password.dart';
import 'package:skill_swap/desktop/presentation/sign/screens/sign_up_screen.dart';
import 'package:skill_swap/shared/bloc/logout_bloc/logout_bloc.dart';
import 'package:skill_swap/shared/bloc/logout_bloc/logout_event.dart';
import 'package:skill_swap/shared/bloc/logout_bloc/logout_state.dart';
import 'package:skill_swap/shared/core/theme/app_palette.dart';

import '../../../shared/bloc/delete_account_bloc/delete_account_bloc.dart';
import '../../../shared/bloc/delete_account_bloc/delete_account_event.dart';
import '../../../shared/bloc/delete_account_bloc/delete_account_state.dart';
import '../sign/screens/sign_in_screen.dart';

class DesktopSidebar extends StatefulWidget {
=======
import 'package:skill_swap/shared/bloc/logout_bloc/logout_bloc.dart';
import 'package:skill_swap/shared/core/theme/app_palette.dart';

import '../../../mobile/presentation/sign/screens/sign_in_screen.dart';
import '../../../shared/bloc/logout_bloc/logout_event.dart';
import '../../../shared/bloc/logout_bloc/logout_state.dart';
import '../sign/screens/sign_in_screen.dart';

class DesktopSidebar extends StatelessWidget {
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const DesktopSidebar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
<<<<<<< HEAD
  State<DesktopSidebar> createState() => _DesktopSidebarState();
}

class _DesktopSidebarState extends State<DesktopSidebar> {
  int? tappedActionIndex;

  void _handleActionTap(int index, VoidCallback action) {
    setState(() {
      tappedActionIndex = index;
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        tappedActionIndex = null;
      });
    });

    action();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 220,
      color: isDark ? AppPalette.darkElevated : AppPalette.lightElevated,
=======
  Widget build(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;

    return Container(
      width: 220,
      color: isDark ? AppPalette.darkSurface : AppPalette.lightSurface,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
<<<<<<< HEAD
            child: MultiBlocListener(
              listeners: [
                BlocListener<LogoutBloc, LogoutState>(
                  listener: (context, state) {
                    if (state is LogoutSuccessState) {
                      Get.snackbar('Success', state.success);
                      Get.offAll(() => const SignInDesktop());
                    } else if (state is LogoutFailureState) {
                      Get.snackbar('Error', state.error);
                    }
                  },
                ),
                BlocListener<DeleteAccountBloc, DeleteAccountState>(
                  listener: (context, state) {
                    if (state is DeleteAccountSuccessState) {
                      Get.offAll(() => const SignUpDesktop());
                    } else if (state is DeleteAccountFailureState) {
                      Get.snackbar(
                        'Error',
                        state.message,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ],
              child: ListView(
                children: [
                  _item(context, Icons.home, "home".tr, 0),
                  _item(context, Icons.chat, "chat".tr, 1),
                  _item(context, Icons.search, "search".tr, 2),
                  _item(context, Icons.schedule, "sessions".tr, 3),
                  _item(context, Icons.person, "profile".tr, 4),
                  _item(context, Icons.storefront_outlined, "store", 5),
                  _item(context, Icons.settings, "setting".tr, 6),
                  const Divider(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "ACCOUNT ACTIONS",
                      style: TextStyle(
                        color: isDark ? Colors.white : AppPalette.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  _actionItem(
                    context,
                    icon: Icons.lock_reset,
                    title: "change_password".tr,
                    index: 7,
                    onTap: () {
                      Get.to(ChangePasswordDesktop());
                    },
                  ),
                  _actionItem(
                    context,
                    icon: Icons.logout,
                    title: "sign_out".tr,
                    index: 8,
                    onTap: () {
                      _showLogoutConfirmation(context);
                    },
                  ),
                  _actionItem(
                    context,
                    icon: Icons.delete,
                    title: "delete_account".tr,
                    index: 9,
                    onTap: () {
                      _showDeleteConfirmation(context);
=======
            child: BlocListener<LogoutBloc, LogoutState>(
              listener: (context, state) {
                if (state is LogoutSuccessState) {
                  Get.snackbar('Success', state.success);
                  Get.offAll(() => const SignInDesktop());
                } else if (state is LogoutFailureState) {
                  Get.snackbar('Error', state.error);
                }
              },
              child: ListView(
                children: [
                  _item(
                    context,
                    icon: Icons.home,
                    title: "home".tr,
                    index: 0,
                  ),
                  _item(
                    context,
                    icon: Icons.chat,
                    title: "chat".tr,
                    index: 1,
                  ),
                  _item(
                    context,
                    icon: Icons.search,
                    title: "search".tr,
                    index: 2,
                  ),
                  _item(
                    context,
                    icon: Icons.schedule,
                    title: "sessions".tr,
                    index: 3,
                  ),
                  _item(
                    context,
                    icon: Icons.person,
                    title: "profile".tr,
                    index: 4,
                  ),
                  _item(
                    context,
                    icon: Icons.settings,
                    title: "setting".tr,
                    index: 5,
                  ),
                  _item(
                    context,
                    icon: Icons.logout,
                    title: "sign_out".tr,
                    index: 6,
                    isAction: true,
                    onAction: () {
                      context.read<LogoutBloc>().add(
                        LogoutRequested(),
                      );
                    },
                  ),
                  _item(
                    context,
                    icon: Icons.delete,
                    title: "delete_account".tr,
                    index: 7,
                    isAction: true,
                    onAction: () {
                      // delete account action
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                    },
                  ),
                ],
              ),
            ),
          ),
<<<<<<< HEAD
          // const Divider(height: 16),
          // const Padding(
          //   padding: EdgeInsets.all(8),
          //   child: UnrealExperienceCard(),
          // ),
=======
          const Divider(height: 20),
          Padding(
            padding: const EdgeInsets.all(8),
            child: UnrealExperienceCard(),
          ),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          const SizedBox(height: 16),
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _item(BuildContext context, IconData icon, String title, int index) {
    final bool active = widget.currentIndex == index;
    final Color color =
        active ? AppPalette.primary : Theme.of(context).iconTheme.color!;

    return _buildTile(
      icon: icon,
      title: title,
      color: color,
      active: active,
      onTap: () => widget.onItemSelected(index),
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
            child: const Text("Cancel"),
          ),
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

  Widget _actionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
    required VoidCallback onTap,
  }) {
    final bool active = tappedActionIndex == index;
    final Color color = active ? Colors.red : Colors.grey;

    return _buildTile(
      icon: icon,
      title: title,
      color: color,
      active: active,
      onTap: () => _handleActionTap(index, onTap),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required Color color,
    required bool active,
    required VoidCallback onTap,
  }) {
=======
  Widget _item(BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
    bool isAction = false,
    VoidCallback? onAction,
  }) {
    final bool active = !isAction && currentIndex == index;

    final Color textColor = isAction
        ? Colors.red
        : active
        ? AppPalette.primary
        : Theme
        .of(context)
        .textTheme
        .bodyMedium!
        .color!;

    final Color? backgroundColor = active
        ? AppPalette.primary.withValues(alpha: 0.15)
        : isAction
        ? Colors.red.withValues(alpha: 0.08)
        : null;

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
<<<<<<< HEAD
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: active ? color.withOpacity(0.15) : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(icon, color: color),
            title: Text(
              title,
              style: TextStyle(
                color: color,
=======
        onTap: () {
          if (onAction != null) {
            onAction();
          } else {
            onItemSelected(index);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(icon, color: textColor),
            title: Text(
              title,
              style: TextStyle(
                color: textColor,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
