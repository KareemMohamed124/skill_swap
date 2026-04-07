import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/core/localization/language_controller.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/core/theme/theme_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Notification settings
  bool emailNotifications = true;
  bool pushNotifications = true;
  bool newMessages = true;
  bool sessionReminders = true;

  // Privacy settings
  bool profileVisibility = true;
  bool showOnlineStatus = true;
  bool directMessages = true;

  // App Preferences
  bool darkMode = false;
  bool soundEffects = true;
  String language = 'English';

  @override
  Widget build(BuildContext context) {
    final sectionPadding = const EdgeInsets.all(8.0);
    final sectionMargin = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);
    final sectionRadius = BorderRadius.circular(12);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
          //  margin: sectionMargin,
            padding: sectionPadding,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: sectionRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1: Notifications
                 Text(
                  'notifications'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge!.color
                  ),
                ),
                const SizedBox(height: 8),
                customSwitch(
                  title: 'email_notifications'.tr,
                  icon: Icons.email_outlined,
                  value: emailNotifications,
                  onChanged: (v) => setState(() => emailNotifications = v),
                ),
                customSwitch(
                  title: 'push_notifications'.tr,
                  icon: Icons.notifications_outlined,
                  value: pushNotifications,
                  onChanged: (v) => setState(() => pushNotifications = v),
                ),
                customSwitch(
                  title: 'new_messages'.tr,
                  icon: Icons.message_outlined,
                  value: newMessages,
                  onChanged: (v) => setState(() => newMessages = v),
                ),
                customSwitch(
                  title: 'session_reminders'.tr,
                  icon: Icons.schedule_outlined,
                  value: sessionReminders,
                  onChanged: (v) => setState(() => sessionReminders = v),
                ),

                const SizedBox(height: 16),
                // Section 2: Privacy
                 Text(
                  'privacy'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color
                  ),
                ),
                const SizedBox(height: 8),
                customSwitch(
                  title: 'profile_visibility'.tr,
                  icon: Icons.person_outline,
                  subtitle: 'allow_find_profile'.tr,
                  value: profileVisibility,
                  onChanged: (v) => setState(() => profileVisibility = v),
                ),
                customSwitch(
                  title: 'show_online_status'.tr,
                  icon: Icons.wifi_tethering_outlined,
                  subtitle: "let_see_online".tr,
                  value: showOnlineStatus,
                  onChanged: (v) => setState(() => showOnlineStatus = v),
                ),
                customSwitch(
                  title: 'direct_messages'.tr,
                  icon: Icons.chat_bubble_outline,
                  subtitle: 'allow_direct_msg'.tr,
                  value: directMessages,
                  onChanged: (v) => setState(() => directMessages = v),
                ),

                const SizedBox(height: 16),
                // Section 3: App Preferences
                 Text(
                  'app_preferences'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color

                  ),
                ),
                const SizedBox(height: 8),
                GetBuilder<ThemeController>(
                    builder: (controller) {
                      return  customSwitch(
                        title: 'dark_mode'.tr,
                        icon: Icons.dark_mode_outlined,
                        value: controller.themeMode == ThemeMode.dark,
                        onChanged: (v) {
                          controller.changeTheme(
                            v ? ThemeMode.dark : ThemeMode.light
                          );
                        },
                      );
                    }
                ),
                const SizedBox(height: 8),
                GetBuilder<LanguageController>(
                  builder: (controller) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.language_outlined),
                            SizedBox(width: 12),
                            Text('language'.tr),
                          ],
                        ),
                        DropdownButton<String>(
                          value: controller.currentLangCode,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 'en', child: Text('English')),
                            DropdownMenuItem(value: 'ar', child: Text('العربية')),
                          ],
                          onChanged: (value) {
                            controller.changeLanguage(value!);
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8),
                customSwitch(
                  title: 'sound_effects'.tr,
                  icon: Icons.volume_up_outlined,
                  value: soundEffects,
                  onChanged: (v) => setState(() => soundEffects = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Custom switch widget for all cases
  Widget customSwitch({
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      secondary: Icon(icon),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.white,
      activeTrackColor: AppPalette.primary,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
    );
  }
}