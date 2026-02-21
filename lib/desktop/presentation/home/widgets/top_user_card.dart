import 'package:flutter/material.dart';

class TopUserCard extends StatelessWidget {
  final String? id;
  final String? image;
  final String? name;
  final String? track;
  final String? hours;
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
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: (image != null && image!.startsWith("http"))
                ? Image.network(
                    image!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(40),
                  )
                : _buildPlaceholder(40),
          ),
          const SizedBox(height: 12),
          Text(
            name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            "${track ?? ''} Developer",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Text(
              hours ?? '',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildPlaceholder(double cardWidth) {
  return Container(
    width: 40,
    height: 40,
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
