import 'package:flutter/material.dart';

class DesktopScaffold extends StatelessWidget {
  final Widget body;
  final Widget? rightPanel;
  final Widget? sidebar; // الجديد: Sidebar اختياري

  const DesktopScaffold({
    super.key,
    required this.body,
    this.rightPanel,
    this.sidebar,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Row(
        children: [
          if (sidebar != null)
            SizedBox(
              width: 220,
              child: sidebar!,
            ),

          /// Main Content
          Expanded(
            child: body,
          ),

          /// Right Panel (Notifications أو أي حاجة ثانية)
          if (width >= 1200 && rightPanel != null)
            SizedBox(
              width: 320,
              child: rightPanel!,
            ),
        ],
      ),
    );
  }
}