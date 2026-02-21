import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../book_session/screens/profile_mentor.dart';

class RecommendedCard extends StatelessWidget {
  final String? id;
  final String? image;
  final String? name;
  final String? track;
  final int? rating;
  final double? width;
  final double? imageHeight;
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
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = double.infinity;
    final cardImageHeight = cardWidth / 2;
    if (isLoading) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: id != null && id!.isNotEmpty
          ? () {
              Get.to(ProfileMentor(
                id: id!,
                name: name ?? '',
                track: track ?? '',
                rate: rating ?? 0,
                image: image ?? '',
              ));
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
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
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.star,
                          size: 16, color: Color(0xFFFFCE31)),
                      const SizedBox(width: 4),
                      Text("$rating",
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  Text(
                    "${track ?? ''} Development",
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
