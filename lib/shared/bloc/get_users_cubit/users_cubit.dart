import 'package:bloc/bloc.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_state.dart';

import '../../data/models/user/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UsersCubit extends Cubit<UsersState> {
  final UserRepository repository;

  int _currentPage = 0;
  bool _isLastPage = false;
  bool _isLoadingMore = false;

  List<UserModel> _users = [];

  UsersCubit(this.repository) : super(UsersInitial());

  Future<void> fetchUsers() async {
    if (_isLoadingMore || _isLastPage) return;

    emit(UsersLoading());

    try {
      final newUsers =
          await repository.getAllUsers(page: _currentPage, limit: 10);
      _users = newUsers;
      _isLastPage = newUsers.length < 10;
      emit(UsersLoaded(_users, isLastPage: _isLastPage));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> fetchNextPage() async {
    if (_isLoadingMore || _isLastPage) return;

    _isLoadingMore = true;
    emit(UsersLoaded(_users, isLastPage: _isLastPage, isLoadingMore: true));

    try {
      _currentPage++;
      final newUsers =
          await repository.getAllUsers(page: _currentPage, limit: 10);

      _users.addAll(newUsers);
      _isLastPage = newUsers.length < 10;
      _isLoadingMore = false;

      emit(UsersLoaded(_users, isLastPage: _isLastPage, isLoadingMore: false));
    } catch (e) {
      _isLoadingMore = false;
      emit(UsersLoaded(_users, isLastPage: _isLastPage, isLoadingMore: false));
      // ممكن emit error state لو عايزة
    }
  }

  void reset() {
    _currentPage = 0;
    _users = [];
    _isLastPage = false;
    _isLoadingMore = false;
    fetchUsers();
  }
}

// class UsersCubit extends Cubit<UsersState> {
//   final UserRepository repository;
//
//   late final PagingController<int, UserModel> pagingController;
//
//   UsersCubit(this.repository) : super(UsersInitial()) {
//     pagingController = PagingController<int, UserModel>(
//       // 1. getNextPageKey → لازم ترجع int? أو null
//       getNextPageKey: (PagingState<int, UserModel> state) {
//         // أول صفحة: ابدأ من 0 (أو 1 لو الـ backend يطلب page=1)
//         if (state.keys?.isEmpty ?? true) {
//           return 1; // ← غيري لـ 1 لو لازم
//         }
//
//         final lastKey = state.keys?.last;
//         if (lastKey == null) return null;
//
//         // لو آخر صفحة جات أقل من 10 → مفيش المزيد
//         final lastItems = state.pages?.last ?? [];
//         if (lastItems.length < 10) {
//           return null;
//         }
//
//         return lastKey + 1;
//       },
//
//       // 2. fetchPage → لازم ترجع Future<List<UserModel>>
//       fetchPage: (int pageKey) async {
//         final newItems = await repository.getAllUsers(
//           page: pageKey,
//           limit: 10,
//         );
//         return newItems;
//       },
//     );
//
//     // ابدأ التحميل الأولي تلقائيًا
//     pagingController.fetchNextPage();
//   }
//
//   Future<void> refresh() async {
//     await refresh();
//   }
//
//   @override
//   Future<void> close() {
//     pagingController.dispose();
//     return super.close();
//   }
// }
