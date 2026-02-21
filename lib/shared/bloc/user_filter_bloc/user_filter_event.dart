import 'package:equatable/equatable.dart';

abstract class UserFilterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApplyFiltersEvent extends UserFilterEvent {
  final double? minPrice;
  final double? maxPrice;
  final double? minRate;
  final String? role;
  final String? skill;
  final String? track;

  ApplyFiltersEvent({
    this.minPrice,
    this.maxPrice,
    this.minRate,
    this.role,
    this.skill,
    this.track,
  });
}

class ResetFiltersEvent extends UserFilterEvent {}

class SearchUserEvent extends UserFilterEvent {
  final String query;

  SearchUserEvent(this.query);
}

enum SortType { priceLowToHigh, priceHighToLow, nameAZ, nameZA, rateHigh }

class SortUserEvent extends UserFilterEvent {
  final SortType type;

  SortUserEvent(this.type);
}
