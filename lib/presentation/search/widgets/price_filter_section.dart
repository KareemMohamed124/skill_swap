import 'package:flutter/material.dart';
import 'package:skill_swap/constants/colors.dart';

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
    priceRange = RangeValues(widget.min + 10, widget.min + 50); // default
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Price Range",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),

        const SizedBox(height: 8),

        RangeSlider(
          values: priceRange,
          min: widget.min,
          max: widget.max,
          divisions: 10,
          activeColor: AppColor.mainColor,
          inactiveColor: Colors.grey[300],
          labels: RangeLabels(
            "${priceRange.start.round()}",
            "${priceRange.end.round()}",
          ),
          onChanged: (values) {
            setState(() => priceRange = values);

            widget.onChanged(
              values.start,
              values.end,
            );
          },
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            priceBox("Min", priceRange.start),
            priceBox("Max", priceRange.end),
          ],
        ),
      ],
    );
  }

  Widget priceBox(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            "\$${value.round()}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        )
      ],
    );
  }
}