import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'activation_event.dart';
import 'activation_state.dart';

class ActivationBloc extends Bloc<ActivationEvent, ActivationState> {
  final AuthRepository repo;

  ActivationBloc(this.repo) : super(ActivationInitial()) {
    on<VerifyActivation>((event, emit) async {
      emit(ActivationLoading());
      try {
        await repo.verifyActivation(event.code);
        emit(ActivationSuccess("Account verified successfully"));
      } catch (e) {
        emit(ActivationFailure(e.toString()));
      }
    });

    on<ResendActivation>((event, emit) async {
      emit(ActivationLoading());
      try {
        await repo.resendActivation(event.email);
        emit(ActivationSuccess("Activation code resent successfully"));
      } catch (e) {
        emit(ActivationFailure(e.toString()));
      }
    });
  }
}
