import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../shared/core/theme/app_palette.dart';

class FilterButton extends StatelessWidget {
  final int activeFilters;
  final VoidCallback? onPressed;

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
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'filter'.tr,
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
