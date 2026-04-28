import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/models/store/item_mapper.dart';
import '../../domain/repositories/store_repository.dart';
import 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  final StoreRepository repository;

  StoreCubit(this.repository)
      : super(StoreState(
          remaining: Duration.zero,
          elapsed: Duration.zero,
          items: [],
        )) {
    _initTimer();
  }

  Timer? timer;
  final box = GetStorage();

  static const String endTimeKey = "store_end_time";

  // ---------------- STORE ITEMS ----------------

  Future<void> getStoreItems() async {
    try {
      emit(state.copyWith(isLoading: true));

      final response = await repository.getItems();
      final items = response.items.map((e) => e.toStoreItem()).toList();

      emit(state.copyWith(
        items: items,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  // ---------------- BUY ITEM ----------------

  Future<void> buyItem(String id) async {
    try {
      final response = await repository.purchaseItem(id);

      final updatedItems = state.items.map((item) {
        if (item.id == id) {
          return item.copyWith(isPurchased: true);
        }
        return item;
      }).toList();

      emit(state.copyWith(
        items: updatedItems,
        successMessage: response.message,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  // ---------------- CLEAR MESSAGE ----------------

  void clearMessage() {
    emit(state.copyWith(
      successMessage: null,
      errorMessage: null,
    ));
  }

  // ---------------- TIMER ----------------

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
      final remaining = endTime.difference(DateTime.now());

      if (remaining.isNegative) {
        timer?.cancel();

        final newEnd = getNextSaturdayMidnight();
        box.write(endTimeKey, newEnd.millisecondsSinceEpoch);

        _startTimer(newEnd);
        return;
      }

      emit(state.copyWith(remaining: remaining));
    });
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }
}
