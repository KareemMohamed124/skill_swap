import '../../../../mobile/presentation/game_stor/models/store_item_model.dart';
import 'item_model.dart';

extension ItemMapper on Item {
  StoreItem toStoreItem() {
    return StoreItem(
      id: id,
      title: title,
      price: priceInPoints,
      image: img.secureUrl.isNotEmpty
          ? img.secureUrl
          : "assets/images/store_images/coin.png",
      rarity: _mapRarity(priceInPoints),
    );
  }

  String _mapRarity(int price) {
    if (price >= 500) return "epic";
    if (price >= 300) return "rare";
    return "common";
  }
}
