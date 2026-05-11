import 'package:flutter/material.dart';
import 'package:get/get.dart';
<<<<<<< HEAD

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import '../../../../shared/core/theme/app_palette.dart';

class FilterButton extends StatelessWidget {
  final int activeFilters;
  final VoidCallback? onPressed;

<<<<<<< HEAD
  const FilterButton({
    super.key,
    this.activeFilters = 0,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = MediaQuery.of(context).size.width;

        final double circleSize = (width * 0.035).clamp(24.0, 36.0);

        return GestureDetector(
          onTap: onPressed,
          child: Container(
            height: 55,
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
=======
  const FilterButton({super.key, this.activeFilters = 0, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380), // زي Search
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            height: 48, // نفس طول Search
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'filter'.tr,
<<<<<<< HEAD
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (activeFilters > 0) ...[
                  SizedBox(width: width * 0.015),
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppPalette.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$activeFilters',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: circleSize * 0.4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
=======
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (activeFilters > 0)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppPalette.primary,
                    ),
                    child: Center(
                      child: Text(
                        '$activeFilters',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
