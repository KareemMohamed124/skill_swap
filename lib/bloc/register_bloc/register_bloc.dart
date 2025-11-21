import 'package:bloc/bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/models/register/register_response.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository repo;

  RegisterBloc(this.repo) : super(RegisterInitial()) {
    on<RegisterSubmit>((event, emit) async {
      emit(RegisterLoading());

      final result = await repo.register(event.request);

      switch (result) {
        case RegisterSuccess s:
          emit(RegisterSuccessState(s.data));
          break;

        case RegisterFailure f:
          emit(RegisterFailureState(f.error));
          break;
      }
    });
  }
}
