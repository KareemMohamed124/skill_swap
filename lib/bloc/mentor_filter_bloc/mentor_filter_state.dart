import 'package:equatable/equatable.dart';
import 'package:skill_swap/constants/strings.dart';

import '../../presentation/search/models/mentor_model.dart';

class MentorFilterState extends Equatable {
  final List<MentorModel> filteredList;

  const MentorFilterState(this.filteredList);

  @override
  List<Object?> get props => [filteredList];
}