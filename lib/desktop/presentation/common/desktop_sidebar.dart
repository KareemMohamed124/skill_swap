import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/common/unreal_card.dart';
import 'package:skill_swap/shared/bloc/logout_bloc/logout_bloc.dart';
import 'package:skill_swap/shared/core/theme/app_palette.dart';

import '../../../mobile/presentation/sign/screens/sign_in_screen.dart';
import '../../../shared/bloc/logout_bloc/logout_event.dart';
import '../../../shared/bloc/logout_bloc/logout_state.dart';

class DesktopSidebar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const DesktopSidebar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 220,
      color: isDark ? AppPalette.darkSurface : AppPalette.lightSurface,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: BlocListener<LogoutBloc, LogoutState>(
              listener: (context, state) {
                if (state is LogoutSuccessState) {
                  Get.snackbar('Success', state.success);
                  Get.offAll(() => const SignInScreen());
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
                    },
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 20),
          Padding(
            padding: const EdgeInsets.all(8),
            child: UnrealExperienceCard(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context, {
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
            : Theme.of(context).textTheme.bodyMedium!.color!;

    final Color? backgroundColor = active
        ? AppPalette.primary.withValues(alpha: 0.15)
        : isAction
            ? Colors.red.withValues(alpha: 0.08)
            : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
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
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
