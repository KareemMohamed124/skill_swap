import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import '../../../mobile/presentation/game_stor/models/store_item_model.dart';
import 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  Timer? timer;
  final box = GetStorage();

  static const String endTimeKey = "store_end_time";

  StoreCubit()
      : super(StoreState(
    coins: 1250,
    remaining: Duration.zero,
    elapsed: Duration.zero,
    items: [
      StoreItem(
        id: "1",
        title: "20% Coupon",
        price: 200,
        image: "assets/images/store_images/coupon20_skillSwap.png",
        rarity: "common",
      ),
      StoreItem(
        id: "2",
        title: "50% Coupon",
        price: 500,
        image: "assets/images/store_images/coupon50_skillSwap.png",
        rarity: "rare",
      ),
      StoreItem(
        id: "3",
        title: "",
        price: 250,
        image: "assets/images/store_images/coin.png",
        rarity: "epic",
      ),
    ],
  )) {
    _initTimer();
  }

  DateTime getNextSaturdayMidnight() {
    final now = DateTime.now();
    int daysToAdd = (6 - now.weekday) % 7;

    if (daysToAdd == 0 && now.hour > 0) {
      daysToAdd = 7;
    }

    final next = DateTime(now.year, now.month, now.day + daysToAdd);
    return DateTime(next.year, next.month, next.day);
  }

  void _initTimer() {
    int? stored = box.read(endTimeKey);

    DateTime endTime;

    if (stored == null) {
      endTime = getNextSaturdayMidnight();
      box.write(endTimeKey, endTime.millisecondsSinceEpoch);
    } else {
      endTime = DateTime.fromMillisecondsSinceEpoch(stored);

      if (DateTime.now().isAfter(endTime)) {
        endTime = getNextSaturdayMidnight();
        box.write(endTimeKey, endTime.millisecondsSinceEpoch);
      }
    }

    _startTimer(endTime);
  }

  void _startTimer(DateTime endTime) {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final remaining = endTime.difference(now);

      if (remaining.isNegative) {
        final newEnd = getNextSaturdayMidnight();
        box.write(endTimeKey, newEnd.millisecondsSinceEpoch);

        _startTimer(newEnd);
        return;
      }
      emit(state.copyWith(
        remaining: remaining,
      ));
    });
  }

  void buyItem(String id, {int? customPrice}) {
    final item = state.items.firstWhere((e) => e.id == id);

    int price = customPrice ?? item.price;

    if (item.isPurchased || state.coins < price) return;

    item.isPurchased = true;

    emit(state.copyWith(
      coins: state.coins - price,
      items: List.from(state.items),
    ));
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }
}
