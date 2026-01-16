import 'package:equatable/equatable.dart';
import '../../presentation/search/models/mentor_model.dart';

class MentorFilterState extends Equatable {
  final List<MentorModel> filteredList;

  // إضافة خصائص كل الفلاتر الحالية
  final double minPrice;
  final double maxPrice;
  final int? selectedRate;
  final String? selectedStatus;
  final String? selectedTrack;
  final String? enteredSkill;

  const MentorFilterState({
    required this.filteredList,
    this.minPrice = 20,
    this.maxPrice = 60,
    this.selectedRate,
    this.selectedStatus,
    this.selectedTrack,
    this.enteredSkill,
  });

  @override
  List<Object?> get props => [
    filteredList,
    minPrice,
    maxPrice,
    selectedRate,
    selectedStatus,
    selectedTrack,
    enteredSkill,
  ];

  MentorFilterState copyWith({
    List<MentorModel>? filteredList,
    double? minPrice,
    double? maxPrice,
    int? selectedRate,
    String? selectedStatus,
    String? selectedTrack,
    String? enteredSkill,
  }) {
    return MentorFilterState(
      filteredList: filteredList ?? this.filteredList,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      selectedRate: selectedRate ?? this.selectedRate,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedTrack: selectedTrack ?? this.selectedTrack,
      enteredSkill: enteredSkill ?? this.enteredSkill,
    );
  }
}