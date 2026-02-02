import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../common_ui/screen_manager/screen_manager.dart';
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
        final user = await repo.getProfile();
        await LocalStorage.saveUser(user);
          emit(LoginSuccessState(s.data));
         Get.to(ScreenManager(initialIndex: 0,));
          break;

        case LoginFailure f:
          emit(LoginFailureState(f.error));
          break;
      }
    });
  }
}
