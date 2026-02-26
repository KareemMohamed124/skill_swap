import 'package:flutter/material.dart';

class RecommendedCard extends StatelessWidget {
  final String? id;
  final String? image;
  final String? name;
  final String? track;
  final int? rating;
  final double? width;
  final double? imageHeight;
  final String? bio;
  final bool isLoading;

  const RecommendedCard({
    super.key,
    this.id,
    this.image,
    this.name,
    this.track,
    this.rating,
    this.width,
    this.imageHeight,
    this.bio,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = width ?? screenWidth * 0.45;
    final cardImageHeight = imageHeight ?? cardWidth * 0.55;

    if (isLoading) {
      return Container(
        width: cardWidth,
        height: cardImageHeight + 60,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image أو placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: (image != null && image!.startsWith("http"))
                ? Image.network(
                    image!,
                    width: double.infinity,
                    height: cardImageHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _buildPlaceholder(cardImageHeight),
                  )
                : _buildPlaceholder(cardImageHeight),
          ),

          SizedBox(height: screenWidth * 0.01),

          Text(
            name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),

          rating != null
              ? Row(
                  children: [
                    Icon(Icons.star,
                        size: screenWidth * 0.03,
                        color: const Color(0xFFFFCE31)),
                    SizedBox(width: screenWidth * 0.01),
                    Text(
                      "$rating",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                )
              : const SizedBox(),

          Text(
            track ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(double height) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade300,
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }
}
