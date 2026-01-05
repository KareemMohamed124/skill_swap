import 'package:flutter/material.dart';
import 'package:skill_swap/constants/colors.dart';

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
      backgroundColor: AppColor.whiteColor,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
          //  margin: sectionMargin,
            padding: sectionPadding,
            decoration: BoxDecoration(
              color: AppColor.grayColor.withValues(alpha: 0.15),
              border: Border.all(color: AppColor.mainColor),
              borderRadius: sectionRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1: Notifications
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                customSwitch(
                  title: 'Email Notifications',
                  icon: Icons.email_outlined,
                  value: emailNotifications,
                  onChanged: (v) => setState(() => emailNotifications = v),
                ),
                customSwitch(
                  title: 'Push Notifications',
                  icon: Icons.notifications_outlined,
                  value: pushNotifications,
                  onChanged: (v) => setState(() => pushNotifications = v),
                ),
                customSwitch(
                  title: 'New Messages',
                  icon: Icons.message_outlined,
                  value: newMessages,
                  onChanged: (v) => setState(() => newMessages = v),
                ),
                customSwitch(
                  title: 'Session Reminders',
                  icon: Icons.schedule_outlined,
                  value: sessionReminders,
                  onChanged: (v) => setState(() => sessionReminders = v),
                ),

                const SizedBox(height: 16),
                // Section 2: Privacy
                const Text(
                  'Privacy',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                customSwitch(
                  title: 'Profile Visibility',
                  icon: Icons.person_outline,
                  subtitle: 'Allow others to find your profile',
                  value: profileVisibility,
                  onChanged: (v) => setState(() => profileVisibility = v),
                ),
                customSwitch(
                  title: 'Show Online Status',
                  icon: Icons.wifi_tethering_outlined,
                  subtitle: "Let others see when you're online",
                  value: showOnlineStatus,
                  onChanged: (v) => setState(() => showOnlineStatus = v),
                ),
                customSwitch(
                  title: 'Direct Messages',
                  icon: Icons.chat_bubble_outline,
                  subtitle: 'Allow others to message you directly',
                  value: directMessages,
                  onChanged: (v) => setState(() => directMessages = v),
                ),

                const SizedBox(height: 16),
                // Section 3: App Preferences
                const Text(
                  'App Preferences',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                customSwitch(
                  title: 'Dark Mode',
                  icon: Icons.dark_mode_outlined,
                  value: darkMode,
                  onChanged: (v) => setState(() => darkMode = v),
                ),
                const SizedBox(height: 8),
                // Language row (غير سويتش)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.language_outlined),
                        SizedBox(width: 12),
                        Text('Language'),
                      ],
                    ),
                    Text(language),
                  ],
                ),
                const SizedBox(height: 8),
                customSwitch(
                  title: 'Sound Effects',
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
      activeColor: AppColor.whiteColor,
      activeTrackColor: AppColor.mainColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
    );
  }
}