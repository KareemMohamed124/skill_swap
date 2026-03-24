import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String name;
  final String review;
  final int rating;
  final String image;

  const ReviewCard({
    super.key,
    required this.name,
    required this.review,
    required this.rating,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.35;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + Name + Stars
          Row(
            children: [
              ClipOval(
                child: (image != null && image!.startsWith("http"))
                    ? Image.network(
                        image!,
                        width: cardWidth * 0.25,
                        height: cardWidth * 0.25,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _buildPlaceholder(cardWidth),
                      )
                    : _buildPlaceholder(cardWidth),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.bodyLarge),
                    Row(
                      children: List.generate(
                        rating,
                        (i) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review,
            style:
                TextStyle(color: Theme.of(context).textTheme.titleSmall!.color),
          ),
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
