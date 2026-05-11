import 'package:flutter/material.dart';

import '../../../../shared/core/theme/app_palette.dart';

class TopUserCard extends StatelessWidget {
  final String? id;
  final String? image;
  final String? name;
  final String? track;
<<<<<<< HEAD
  final num? hours;
=======
  final int? hours;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  final double? widthCard;
  final bool isLoading;

  const TopUserCard({
    super.key,
    this.widthCard,
    this.id,
    this.image,
    this.name,
    this.track,
    this.hours,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
<<<<<<< HEAD
    final cardWidth = widthCard ?? screenWidth * 0.36;
=======
    final cardWidth = widthCard ?? screenWidth * 0.35;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

    if (isLoading) {
      return Container(
        width: cardWidth,
        height: cardWidth * 1.2,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: const Center(
          child: CircularProgressIndicator(
              color: AppPalette.primary, strokeWidth: 2),
        ),
      );
    }

    return Container(
      width: cardWidth,
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: screenWidth * 0.02),

<<<<<<< HEAD
          /// Avatar أ
=======
          /// Avatar أو placeholder
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          ClipOval(
            child: (image != null && image!.startsWith("http"))
                ? Image.network(
                    image!,
                    width: cardWidth * 0.25,
                    height: cardWidth * 0.25,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(cardWidth),
                  )
                : _buildPlaceholder(cardWidth),
          ),

          SizedBox(height: screenWidth * 0.02),

          Text(
            name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
<<<<<<< HEAD
            style: Theme.of(context).textTheme.titleSmall,
=======
            style: Theme.of(context).textTheme.bodySmall,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          ),

          Text(
            track ?? "Mobile Development",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
<<<<<<< HEAD
            style: Theme.of(context).textTheme.bodySmall,
=======
            style: Theme.of(context).textTheme.titleSmall,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          ),

          SizedBox(height: screenWidth * 0.01),

          Container(
            width: cardWidth * 0.35,
            height: screenWidth * 0.04,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Center(
              child: Text(
                "$hours" ?? '',
                style: TextStyle(
                  fontSize: 8,
                  color: Theme.of(context).textTheme.titleSmall!.color,
                ),
              ),
            ),
          ),

          SizedBox(height: screenWidth * 0.02),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(double cardWidth) {
    return Container(
      width: cardWidth * 0.25,
      height: cardWidth * 0.25,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
      ),
    );
  }
}
