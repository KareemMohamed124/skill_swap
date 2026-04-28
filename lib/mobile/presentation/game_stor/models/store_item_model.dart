class StoreItem {
  final String id;
  final String title;
  final int price;
  final String image;
  final String rarity;

  final bool isLocked; // 👈 NEW
  final bool isPurchased;

  StoreItem({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.rarity,
    this.isLocked = false,
    this.isPurchased = false,
  });

  StoreItem copyWith({
    String? id,
    String? title,
    int? price,
    String? image,
    String? rarity,
    bool? isLocked,
    bool? isPurchased,
  }) {
    return StoreItem(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      rarity: rarity ?? this.rarity,
      isLocked: isLocked ?? this.isLocked,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }
}
