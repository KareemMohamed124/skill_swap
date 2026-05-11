import 'package:flutter_bloc/flutter_bloc.dart';

<<<<<<< HEAD
import '../../core/services/notification_service.dart';
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import '../../data/models/login/login_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../helper/local_storage.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repo;

  LoginBloc(this.repo) : super(LoginInitial()) {
    on<LoginSubmit>((event, emit) async {
      emit(LoginLoading());

      final result = await repo.login(event.request);

      switch (result) {
        case LoginSuccess s:
          await LocalStorage.saveToken(s.data.accessToken);
          await LocalStorage.saveRefreshToken(s.data.refreshToken);
          await LocalStorage.saveUserId(s.data.id);
<<<<<<< HEAD
          NotificationService.init();
=======
          //  await LocalStorage.saveUser(s.data.)
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          emit(LoginSuccessState(s.data));
          break;

        case LoginFailure f:
          emit(LoginFailureState(f.error));
          break;
      }
    });
  }
}
