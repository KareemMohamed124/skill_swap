import 'package:bloc/bloc.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_state.dart';

import '../../data/models/user/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UsersCubit extends Cubit<UsersState> {
  final UserRepository repository;

  UsersCubit(this.repository) : super(UsersInitial());

  int _currentPage = 1;
  bool _isLastPage = false;
  bool _isLoadingMore = false;

  final List<UserModel> _users = [];
  final Set<String> _userIds = {};

  Future<void> fetchUsers({bool reset = false}) async {
    if (_isLoadingMore) return;

    if (reset) {
      _currentPage = 1;
      _users.clear();
      _userIds.clear();
      _isLastPage = false;
      emit(UsersLoading());
    }

    if (_isLastPage) return;

    _isLoadingMore = true;

    if (state is UsersLoaded) {
      emit((state as UsersLoaded).copyWith(isLoadingMore: true));
    }

    try {
      final newUsers = await repository.getAllUsers(
        page: _currentPage,
        limit: 10,
      );

      final uniqueNewUsers = newUsers.where((u) => _userIds.add(u.id)).toList();
      _users.addAll(uniqueNewUsers);
      _isLastPage = newUsers.isEmpty;
      _isLoadingMore = false;

      emit(UsersLoaded(
        List.from(_users),
        isLastPage: _isLastPage,
        isLoadingMore: false,
      ));

      _currentPage++;
    } catch (e) {
      _isLoadingMore = false;
      emit(UsersError(e.toString()));
    }
  }

  Future<void> fetchNextPage() async {
    await fetchUsers();
  }
}
