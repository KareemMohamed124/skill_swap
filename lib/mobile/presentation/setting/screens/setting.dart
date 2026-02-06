import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../profile/widgets/profile_tabs.dart';
import '../pages/account_page.dart';
import '../pages/edit_profile_page.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        title: "settings".tr,
        child: Column(
          children: [
            ProfileTabs(
              tabController: _tabController,
              tabs: ['edit_profile'.tr, 'preferences'.tr],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  EditProfilePage(),
                  SettingsPage(),
                ],
              ),
            ),
          ],
        ));
  }
}
