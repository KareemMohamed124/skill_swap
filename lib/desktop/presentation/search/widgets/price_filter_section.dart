import 'package:flutter/material.dart';
import 'package:get/get.dart';
<<<<<<< HEAD

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import '../../../../shared/core/theme/app_palette.dart';

class PriceFilterSection extends StatefulWidget {
  final double min;
  final double max;
  final Function(double start, double end) onChanged;

  const PriceFilterSection({
    super.key,
    this.min = 0,
    this.max = 100,
    required this.onChanged,
  });

  @override
  State<PriceFilterSection> createState() => _PriceFilterSectionState();
}

class _PriceFilterSectionState extends State<PriceFilterSection> {
  late RangeValues priceRange;

  @override
  void initState() {
    super.initState();
    priceRange = RangeValues(widget.min + 10, widget.min + 50);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "price_range".tr,
          style: Theme.of(context).textTheme.titleMedium,
        ),
<<<<<<< HEAD
        SizedBox(height: width * 0.02),
=======

        SizedBox(height: width * 0.02),

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        RangeSlider(
          values: priceRange,
          min: widget.min,
          max: widget.max,
          divisions: 10,
          activeColor: AppPalette.primary,
          inactiveColor: Colors.grey[300],
          labels: RangeLabels(
            "${priceRange.start.round()}",
            "${priceRange.end.round()}",
          ),
          onChanged: (values) {
            setState(() => priceRange = values);
            widget.onChanged(values.start, values.end);
          },
        ),
<<<<<<< HEAD
        SizedBox(height: width * 0.01),
=======

        SizedBox(height: width * 0.01),

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        Row(
          children: [
            Expanded(child: priceBox("min".tr, priceRange.start)),
            SizedBox(width: width * 0.04),
            Expanded(child: priceBox("max".tr, priceRange.end)),
          ],
        ),
      ],
    );
  }

  Widget priceBox(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
<<<<<<< HEAD
        SizedBox(height: 4),
=======

        SizedBox(height: 4),

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        Container(
          height: 40,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
            color: Theme.of(context).cardColor,
          ),
          child: Text(
            "\$${value.round()}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
<<<<<<< HEAD
  }
}
=======
  }}
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
