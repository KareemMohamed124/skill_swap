import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/user/user_model.dart';
import '../../domain/repositories/user_repository.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UserRepository repository;

  UsersCubit(this.repository) : super(UsersInitial());

  void fetchUsers() async {
    emit(UsersLoading());

    try {
      final users = await repository.getAllUsers();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }
}
