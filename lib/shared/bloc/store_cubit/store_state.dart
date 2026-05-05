import 'package:equatable/equatable.dart';

import '../../../mobile/presentation/game_stor/models/store_item_model.dart';

class StoreState extends Equatable {
  final Duration remaining;
  final Duration elapsed;
  final List<StoreItem> items;

  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const StoreState({
    required this.remaining,
    required this.elapsed,
    required this.items,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  StoreState copyWith({
    Duration? remaining,
    Duration? elapsed,
    List<StoreItem>? items,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return StoreState(
      remaining: remaining ?? this.remaining,
      elapsed: elapsed ?? this.elapsed,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        remaining,
        elapsed,
        items,
        isLoading,
        errorMessage,
        successMessage,
      ];
}
