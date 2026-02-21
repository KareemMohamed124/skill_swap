import 'package:bloc/bloc.dart';
import 'package:skill_swap/shared/bloc/user_filter_bloc/user_filter_event.dart';
import 'package:skill_swap/shared/bloc/user_filter_bloc/user_filter_state.dart';

import '../../data/models/user/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UserFilterBloc extends Bloc<UserFilterEvent, UserFilterState> {
  final UserRepository userRepository;

  UserFilterBloc({
    required this.userRepository,
    required List<UserModel> allUsers,
  }) : super(UserFilterState(filteredList: allUsers)) {
    on<SearchUserEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final users = await userRepository.searchUsers(query: event.query);

      emit(state.copyWith(
        filteredList: users,
        isLoading: false,
        enteredSkill: event.query,
      ));
    });

    on<ApplyFiltersEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final users = await userRepository.filterUsers(
        role: event.role,
        track: event.track,
        minRating: event.minRate?.toInt(),
        minPrice: event.minPrice?.toInt(),
        maxPrice: event.maxPrice?.toInt(),
      );

      emit(state.copyWith(
        filteredList: users,
        isLoading: false,
        minPrice: event.minPrice ?? state.minPrice,
        maxPrice: event.maxPrice ?? state.maxPrice,
        selectedRate: event.minRate?.toInt(),
        selectedRole: event.role,
        selectedTrack: event.track,
        enteredSkill: event.skill,
      ));
    });

    on<SortUserEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      String sortQuery = _mapSortType(event.type);

      final users = await userRepository.sortUsers(query: sortQuery);

      emit(state.copyWith(
        filteredList: users,
        isLoading: false,
      ));
    });

    on<ResetFiltersEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final users = await userRepository.getAllUsers();

      emit(UserFilterState(filteredList: users));
    });
  }

  String _mapSortType(SortType type) {
    switch (type) {
      case SortType.priceLowToHigh:
        return "price_asc";
      case SortType.priceHighToLow:
        return "price_desc";
      case SortType.nameAZ:
        return "name_asc";
      case SortType.nameZA:
        return "name_desc";
      case SortType.rateHigh:
        return "rate_desc";
    }
  }
}
