import 'package:flutter/material.dart';

class DesktopScaffold extends StatelessWidget {
  final Widget body;
  final Widget? rightPanel;
<<<<<<< HEAD
  final Widget? sidebar;
=======
  final Widget? sidebar; // الجديد: Sidebar اختياري
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  const DesktopScaffold({
    super.key,
    required this.body,
    this.rightPanel,
    this.sidebar,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
<<<<<<< HEAD
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background, // 👈 الخلفية العامة
      body: Row(
        children: [
          /// Sidebar
          if (sidebar != null)
            Container(
              width: 250,
              color: colors.surfaceVariant,
=======

    return Scaffold(
      body: Row(
        children: [
          if (sidebar != null)
            SizedBox(
              width: 220,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              child: sidebar!,
            ),

          /// Main Content
          Expanded(
<<<<<<< HEAD
            child: Container(
              color: colors.surface,
              child: body,
            ),
          ),

          /// Right Panel
          if (width >= 900 && rightPanel != null)
            Container(
              width: 350,
              color: colors.surfaceVariant,
=======
            child: body,
          ),

          /// Right Panel (Notifications أو أي حاجة ثانية)
          if (width >= 1200 && rightPanel != null)
            SizedBox(
              width: 320,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              child: rightPanel!,
            ),
        ],
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
