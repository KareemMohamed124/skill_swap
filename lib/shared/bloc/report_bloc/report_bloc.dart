import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/report_user/report_error_response.dart';
import '../../data/models/report_user/report_request.dart';
import '../../data/models/report_user/report_response.dart';
import '../../data/models/report_user/report_success_response.dart';
import '../../domain/repositories/report_repository.dart';

part 'report_event.dart';
<<<<<<< HEAD
=======

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository repository;

  ReportBloc(this.repository) : super(ReportInitial()) {
    on<ConfirmSubmit>((event, emit) async {
      emit(ReportLoading());

<<<<<<< HEAD
      try {
        final result = await repository.report(event.request);

        switch (result) {
          case ReportSuccess s:
            emit(ReportSuccessState(s.success));
            break;

          case ReportFailure f:
            emit(ReportFailureState(f.error));
            break;

          default:
            emit(ReportFailureState(
              ReportErrorResponse(message: "Unknown response"),
            ));
        }
      } catch (e) {
        emit(ReportFailureState(
          ReportErrorResponse(message: e.toString()),
        ));
=======
      final result = await repository.report(event.request);

      switch (result) {
        case ReportSuccess s:
          emit(ReportSuccessState(s.success));
          break;
        case ReportFailure f:
          emit(ReportFailureState(f.error));
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      }
    });
  }
}
