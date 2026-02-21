import 'package:equatable/equatable.dart';

import '../../data/models/user/user_model.dart';

class UserFilterState extends Equatable {
  final List<UserModel> filteredList;
  final bool isLoading;

  final double minPrice;
  final double maxPrice;
  final int? selectedRate;
  final String? selectedRole;
  final String? selectedTrack;
  final String? enteredSkill;

  const UserFilterState({
    required this.filteredList,
    this.isLoading = false,
    this.minPrice = 20,
    this.maxPrice = 60,
    this.selectedRate,
    this.selectedRole,
    this.selectedTrack,
    this.enteredSkill,
  });

  @override
  List<Object?> get props => [
        filteredList,
        isLoading,
        minPrice,
        maxPrice,
        selectedRate,
        selectedRole,
        selectedTrack,
        enteredSkill,
      ];

  UserFilterState copyWith({
    List<UserModel>? filteredList,
    bool? isLoading,
    double? minPrice,
    double? maxPrice,
    int? selectedRate,
    String? selectedRole,
    String? selectedTrack,
    String? enteredSkill,
  }) {
    return UserFilterState(
      filteredList: filteredList ?? this.filteredList,
      isLoading: isLoading ?? this.isLoading,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      selectedRate: selectedRate ?? this.selectedRate,
      selectedRole: selectedRole ?? this.selectedRole,
      selectedTrack: selectedTrack ?? this.selectedTrack,
      enteredSkill: enteredSkill ?? this.enteredSkill,
    );
  }
}
