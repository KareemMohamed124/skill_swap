import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/bloc/delete_account_bloc/delete_account_event.dart';

import '../../data/models/delete_account/delete_account_response.dart';
import '../../domain/repositories/user_repository.dart';
import 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final UserRepository repo;

  DeleteAccountBloc(this.repo) : super(DeleteAccountInitial()) {
    on<DeleteAccountSubmit>((event, emit) async {
      emit(DeleteAccountLoading());

      final result = await repo.deleteAccount();

      switch (result) {
        case DeleteAccountSuccess():
          emit(DeleteAccountSuccessState());
          break;

        case DeleteAccountFailure f:
          emit(DeleteAccountFailureState(f.message));
          break;
      }
    });
  }
}
