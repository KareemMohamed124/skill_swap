import 'package:flutter/material.dart';
import 'info_field.dart';

class AccountActionsSection extends StatelessWidget {
  const AccountActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // هنا بناخد حجم الشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // ممكن نعمل padding يعتمد على حجم الشاشة
    final horizontalPadding = screenWidth * 0.04; // 4% من عرض الشاشة
    final verticalPadding = screenHeight * 0.02; // 2% من ارتفاع الشاشة

    return Container(
      decoration: boxDecoration(),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle("Account Actions"),
          SizedBox(height: screenHeight * 0.01), // حجم فاصل ديناميكي
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text(
              "Delete Account",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
