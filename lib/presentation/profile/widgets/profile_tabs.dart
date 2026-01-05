import 'package:flutter/material.dart';

class ProfileTabs extends StatelessWidget {
  final TabController tabController;
  final List<String> tabs;

  const ProfileTabs({
    Key? key,
    required this.tabController,
    required this.tabs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF2F5F8);
    const Color indicatorColor = Color(0xFF1B1464);
    const double borderRadiusValue = 20;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadiusValue),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: TabBar(
          controller: tabController,
          indicator: BoxDecoration(
            color: indicatorColor,
            borderRadius: BorderRadius.circular(borderRadiusValue - 2),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,

          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,

          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),

          /// 🔥 Tabs ديناميك
          tabs: tabs.map((title) => Tab(text: title)).toList(),
        ),
      ),
    );
  }
}