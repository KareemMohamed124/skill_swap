import 'package:equatable/equatable.dart';

import '../../../mobile/presentation/game_stor/models/store_item_model.dart';

class StoreState extends Equatable {
  final int coins;
  final Duration remaining;
  final Duration elapsed;
  final List<StoreItem> items;

  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const StoreState({
    required this.coins,
    required this.remaining,
    required this.elapsed,
    required this.items,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  StoreState copyWith({
    int? coins,
    Duration? remaining,
    Duration? elapsed,
    List<StoreItem>? items,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return StoreState(
      coins: coins ?? this.coins,
      remaining: remaining ?? this.remaining,
      elapsed: elapsed ?? this.elapsed,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        coins,
        remaining,
        elapsed,
        items,
        isLoading,
        errorMessage,
        successMessage,
      ];
}
