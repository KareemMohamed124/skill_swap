import 'package:equatable/equatable.dart';

import '../../../mobile/presentation/game_stor/models/store_item_model.dart';

class StoreState extends Equatable {
  final int coins;
  final Duration remaining;
  final Duration elapsed;
  final List<StoreItem> items;

  const StoreState({
    required this.coins,
    required this.remaining,
    required this.elapsed,
    required this.items,
  });

  StoreState copyWith({
    int? coins,
    Duration? remaining,
    Duration? elapsed,
    List<StoreItem>? items,
  }) {
    return StoreState(
      coins: coins ?? this.coins,
      remaining: remaining ?? this.remaining,
      elapsed: elapsed ?? this.elapsed,
      items: items ?? this.items,
    );
  }

  @override
  List<Object> get props => [
        coins,
        remaining,
        elapsed,
        items,
      ];
}
