import 'package:skill_swap/shared/data/models/store/store_img.dart';

class Item {
  final String id;
  final StoreImage img;
  final String title;
  final String type;
  final int priceInPoints;
  final String value;
  final int validityDays;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Item(
      {required this.id,
      required this.img,
      required this.title,
      required this.type,
      required this.priceInPoints,
      required this.value,
      required this.validityDays,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt,
      required this.v});

  factory Item.fromJson(Map<String, dynamic>? json) {
    return Item(
      id: json?['_id'] ?? '',
      img: json?['img'] != null
          ? StoreImage.fromJson(json?['img'])
          : StoreImage.empty(),
      title: json?['title'] ?? '',
      type: json?['type'] ?? '',
      priceInPoints: json?['priceInPoints'] ?? 0,
      value: json?['value'] ?? '',
      validityDays: json?['validityDays'] ?? 0,
      isActive: json?['isActive'] ?? false,
      createdAt: DateTime.tryParse(json?['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json?['updatedAt'] ?? '') ?? DateTime.now(),
      v: json?['__v'] ?? 0,
    );
  }
}
