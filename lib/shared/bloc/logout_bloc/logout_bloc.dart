import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/helper/local_storage.dart';

import '../../data/models/logout/logout_response.dart';
import '../../domain/repositories/auth_repository.dart';
import 'logout_event.dart';
import 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRepository repository;

  LogoutBloc(this.repository) : super(LogoutInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<LogoutState> emit) async {
    emit(LogoutLoading());

    final response = await repository.logout();

    if (response is LogoutSuccess) {
      await LocalStorage.clearAllTokens();
      await LocalStorage.clearUserId();
      //await LocalStorage.clearUser();
      //sl<MyProfileCubit>().emit(MyProfileInitial());
      emit(LogoutSuccessState(success: response.message));
    } else if (response is LogoutFailure) {
      emit(LogoutFailureState(error: response.message));
    }
  }
}
