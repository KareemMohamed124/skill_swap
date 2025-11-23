import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skill_swap/data/models/verify_code/verify_code_request.dart';
import 'package:skill_swap/domain/repositories/auth_repository.dart';

import '../../data/models/verify_code/verify_code_error_response.dart';
import '../../data/models/verify_code/verify_code_response.dart';
import '../../data/models/verify_code/verify_code_success_response.dart';

part 'verify_code_event.dart';
part 'verify_code_state.dart';

class VerifyCodeBloc extends Bloc<VerifyCodeEvent, VerifyCodeState> {
  final AuthRepository repository;
  VerifyCodeBloc(this.repository) : super(VerifyCodeInitial()) {
    on<SubmitVerify>((event, emit) async{
      emit(VerifyCodeLoading());

        final request = VerifyCodeRequest(
            email: event.email,
            forgetCode: event.forgetCode,
        );
         final result = await repository.verifyCode(request);

        switch(result) {
          case VerifyCodeSuccess s:
            emit(VerifyCodeSuccessState(s.data));
            break;
          case VerifyCodeFailure f:
            emit(VerifyCodeFailureState(f.error));
            break;
        }
    });
  }
}
