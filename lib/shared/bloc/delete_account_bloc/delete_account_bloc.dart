import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/delete_account/delete_account_response.dart';
import '../../domain/repositories/auth_repository.dart';
import 'delete_account_event.dart';
import 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final AuthRepository repo;

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
