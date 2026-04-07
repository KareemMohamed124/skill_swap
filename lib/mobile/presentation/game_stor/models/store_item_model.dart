class StoreItem {
  final String id;
  final String title;
  final int price;
  final String image;
  final String rarity;
  bool isPurchased;

  StoreItem({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.rarity,
    this.isPurchased = false,
  });
}
