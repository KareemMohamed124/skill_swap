import 'package:bloc/bloc.dart';
import 'package:skill_swap/shared/bloc/user_filter_bloc/user_filter_event.dart';
import 'package:skill_swap/shared/bloc/user_filter_bloc/user_filter_state.dart';

import '../../data/models/user/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UserFilterBloc extends Bloc<UserFilterEvent, UserFilterState> {
  final UserRepository userRepository;
  final int limit;

  int _currentPage = 1;
<<<<<<< HEAD
=======
  bool _isLastPage = false;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  bool _isLoadingMore = false;

  int get currentPage => _currentPage;

<<<<<<< HEAD
  UserFilterBloc({
    required this.userRepository,
    required List<UserModel> allUsers,
    this.limit = 10,
    int initialPage = 1,
  })  : _currentPage = initialPage,
=======
  UserFilterBloc(
      {required this.userRepository,
      required List<UserModel> allUsers,
      this.limit = 10,
      int initialPage = 1})
      : _currentPage = initialPage,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        super(UserFilterState(filteredList: allUsers)) {
    on<SearchUserEvent>((event, emit) async {
      if (_isLoadingMore) return;

<<<<<<< HEAD
      emit(state.copyWith(
        isLoading: true,
        filteredList: [],
        isLastPage: false,
      ));

      _currentPage = 1;
=======
      emit(state.copyWith(isLoading: true));

      _currentPage = 1;
      _isLastPage = false;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

      final users = await userRepository.searchUsers(
        query: event.query,
        page: _currentPage,
        limit: limit,
      );

<<<<<<< HEAD
      final isLastPage = users.isEmpty || users.length < limit;

      emit(state.copyWith(
        filteredList: users,
        isLoading: false,
        isLastPage: isLastPage,
=======
      emit(state.copyWith(
        filteredList: users,
        isLoading: false,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      ));
    });

    on<ApplyFiltersEvent>((event, emit) async {
      if (_isLoadingMore) return;

<<<<<<< HEAD
      emit(state.copyWith(
        isLoading: true,
        filteredList: [],
        isLastPage: false,
      ));

      _currentPage = 1;
=======
      emit(state.copyWith(isLoading: true));

      _currentPage = 1;
      _isLastPage = false;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

      final users = await userRepository.filterUsers(
        role: event.role,
        track: event.track,
        minRating: event.minRate?.toInt(),
        minPrice: event.minPrice?.toInt(),
        maxPrice: event.maxPrice?.toInt(),
        page: _currentPage,
        limit: limit,
      );

<<<<<<< HEAD
      final isLastPage = users.isEmpty || users.length < limit;

      emit(state.copyWith(
        filteredList: users,
        isLoading: false,
        isLastPage: isLastPage,
        minPrice: event.minPrice ?? 0,
        maxPrice: event.maxPrice ?? 20,
        selectedRate: event.minRate != null ? event.minRate!.toInt() : null,
=======
      emit(state.copyWith(
        filteredList: users,
        isLoading: false,
        minPrice: event.minPrice ?? state.minPrice,
        maxPrice: event.maxPrice ?? state.maxPrice,
        selectedRate: event.minRate?.toInt(),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        selectedRole: event.role,
        selectedTrack: event.track,
      ));
    });
<<<<<<< HEAD
    on<SortUserEvent>((event, emit) async {
      if (_isLoadingMore) return;

      emit(state.copyWith(
        isLoading: true,
        filteredList: [],
        isLastPage: false,
      ));

      _currentPage = 1;
=======

    on<SortUserEvent>((event, emit) async {
      if (_isLoadingMore) return;

      emit(state.copyWith(isLoading: true));

      _currentPage = 1;
      _isLastPage = false;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

      final users = await userRepository.sortUsers(
        query: _mapSortType(event.type),
        page: _currentPage,
        limit: limit,
      );

<<<<<<< HEAD
      final isLastPage = users.isEmpty || users.length < limit;

      emit(state.copyWith(
        filteredList: users,
        isLoading: false,
        isLastPage: isLastPage,
=======
      emit(state.copyWith(
        filteredList: users,
        isLoading: false,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      ));
    });

    on<ResetFiltersEvent>((event, emit) async {
      if (_isLoadingMore) return;

<<<<<<< HEAD
      emit(state.copyWith(
        isLoading: true,
        filteredList: [],
        isLastPage: false,
        selectedRole: null,
        selectedTrack: null,
        selectedRate: null,
        minPrice: 0,
        maxPrice: 20,
      ));

      _currentPage = 1;

      final users =
          await userRepository.getAllUsers(page: _currentPage, limit: limit);
      final isLastPage = users.isEmpty || users.length < limit;

      emit(state.copyWith(
        filteredList: users,
        isLoading: false,
        isLastPage: isLastPage,
        selectedRole: null,
        selectedTrack: null,
        selectedRate: null,
        minPrice: 0,
        maxPrice: 20,
      ));
    });

    on<LoadMoreUsersEvent>((event, emit) async {
      if (state.isLastPage || _isLoadingMore) return;

      _isLoadingMore = true;

=======
      emit(state.copyWith(isLoading: true));

      _currentPage = 1;
      _isLastPage = false;

      final users =
          await userRepository.getAllUsers(page: _currentPage, limit: limit);

      emit(UserFilterState(filteredList: users));
    });

    on<LoadMoreUsersEvent>((event, emit) async {
      if (_isLastPage || _isLoadingMore) return;

      _isLoadingMore = true;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      emit(state.copyWith(isLoadingMore: true));

      final nextPage = _currentPage + 1;
      List<UserModel> newUsers = [];

      if (event.query != null && event.query!.isNotEmpty) {
        newUsers = await userRepository.searchUsers(
          query: event.query!,
          page: nextPage,
          limit: limit,
        );
      } else if (event.role != null ||
          event.track != null ||
          event.minRate != null ||
          event.minPrice != null ||
          event.maxPrice != null) {
        newUsers = await userRepository.filterUsers(
          role: event.role,
          track: event.track,
          minRating: event.minRate?.toInt(),
          minPrice: event.minPrice?.toInt(),
          maxPrice: event.maxPrice?.toInt(),
          page: nextPage,
          limit: limit,
        );
      } else {
        newUsers = await userRepository.getAllUsers(
          page: nextPage,
          limit: limit,
        );
      }

<<<<<<< HEAD
      final isLastPage = newUsers.isEmpty || newUsers.length < limit;

      _currentPage = nextPage;

      final allUsers = [...state.filteredList, ...newUsers];

      // إزالة التكرار
      final uniqueUsers = {for (var u in allUsers) u.id: u}.values.toList();

      _isLoadingMore = false;

      emit(state.copyWith(
        filteredList: uniqueUsers,
        isLastPage: isLastPage,
=======
      _isLastPage = newUsers.length < limit;
      _currentPage = nextPage;

      final allUsers = [...state.filteredList, ...newUsers];
      final uniqueUsers = {for (var u in allUsers) u.id: u}.values.toList();

      _isLoadingMore = false;
      emit(state.copyWith(
        filteredList: uniqueUsers,
        isLastPage: _isLastPage,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        isLoadingMore: false,
      ));
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
