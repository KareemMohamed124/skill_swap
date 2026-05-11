import 'package:equatable/equatable.dart';

import '../../data/models/user/user_model.dart';

<<<<<<< HEAD
// sentinel ثابت للتمييز بين "مش بعتلك حاجة" و "بعتلك null"
const _undefined = Object();

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
class UserFilterState extends Equatable {
  final List<UserModel> filteredList;
  final bool isLoading;

  final double minPrice;
  final double maxPrice;
  final int? selectedRate;
  final String? selectedRole;
  final String? selectedTrack;

  final bool isLastPage;
  final bool isLoadingMore;

<<<<<<< HEAD
  const UserFilterState({
    required this.filteredList,
    this.isLoading = false,
    this.minPrice = 20,
    this.maxPrice = 60,
    this.selectedRate,
    this.selectedRole,
    this.selectedTrack,
    this.isLastPage = false,
    this.isLoadingMore = false,
  });
=======
  const UserFilterState(
      {required this.filteredList,
      this.isLoading = false,
      this.minPrice = 20,
      this.maxPrice = 60,
      this.selectedRate,
      this.selectedRole,
      this.selectedTrack,
      this.isLastPage = false,
      this.isLoadingMore = false});
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  @override
  List<Object?> get props => [
        filteredList,
        isLoading,
        minPrice,
        maxPrice,
        selectedRate,
        selectedRole,
        selectedTrack,
        isLastPage,
<<<<<<< HEAD
        isLoadingMore,
      ];

  UserFilterState copyWith({
    List<UserModel>? filteredList,
    bool? isLoading,
    double? minPrice,
    double? maxPrice,
    Object? selectedRate = _undefined,
    Object? selectedRole = _undefined,
    Object? selectedTrack = _undefined,
    bool? isLastPage,
    bool? isLoadingMore,
  }) {
    return UserFilterState(
      filteredList: filteredList ?? this.filteredList,
      isLoading: isLoading ?? this.isLoading,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      selectedRate:
          selectedRate == _undefined ? this.selectedRate : selectedRate as int?,
      selectedRole: selectedRole == _undefined
          ? this.selectedRole
          : selectedRole as String?,
      selectedTrack: selectedTrack == _undefined
          ? this.selectedTrack
          : selectedTrack as String?,
      isLastPage: isLastPage ?? this.isLastPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
=======
        isLoadingMore
      ];

  UserFilterState copyWith(
      {List<UserModel>? filteredList,
      bool? isLoading,
      double? minPrice,
      double? maxPrice,
      int? selectedRate,
      String? selectedRole,
      String? selectedTrack,
      bool? isLastPage,
      bool? isLoadingMore}) {
    return UserFilterState(
        filteredList: filteredList ?? this.filteredList,
        isLoading: isLoading ?? this.isLoading,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        selectedRate: selectedRate ?? this.selectedRate,
        selectedRole: selectedRole ?? this.selectedRole,
        selectedTrack: selectedTrack ?? this.selectedTrack,
        isLastPage: isLastPage ?? this.isLastPage,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore);
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  }
}
