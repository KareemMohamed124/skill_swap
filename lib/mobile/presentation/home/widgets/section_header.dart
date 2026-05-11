import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SectionHeader extends StatelessWidget {
  final String sectionTitle;
  final VoidCallback? onTop;
<<<<<<< HEAD

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  const SectionHeader({
    super.key,
    required this.sectionTitle,
    required this.onTop,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            sectionTitle,
<<<<<<< HEAD
            style: Theme.of(context).textTheme.bodyLarge,
=======
            style: Theme.of(context).textTheme.bodySmall,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          ),
        ),
        GestureDetector(
          onTap: onTop,
          child: Row(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "view_all".tr,
<<<<<<< HEAD
                  style: Theme.of(context).textTheme.bodyLarge,
=======
                  style: Theme.of(context).textTheme.bodySmall,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                ),
              ),
              SizedBox(width: screenWidth * 0.02), // بدل 8
              Icon(
                Icons.arrow_forward_ios,
                size: screenWidth * 0.04, // بدل 16
<<<<<<< HEAD
                color: Theme.of(context).textTheme.bodyLarge!.color,
=======
                color: Theme.of(context).textTheme.titleMedium!.color,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              ),
            ],
          ),
        ),
      ],
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
