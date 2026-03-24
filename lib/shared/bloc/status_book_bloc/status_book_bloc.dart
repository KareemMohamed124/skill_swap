import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/status_booking/status_booking_error_response.dart';
import '../../data/models/status_booking/status_booking_request.dart';
import '../../data/models/status_booking/status_booking_response.dart';
import '../../domain/repositories/booking_repository.dart';

part 'status_book_event.dart';

part 'status_book_state.dart';

class StatusBookBloc extends Bloc<StatusBookEvent, StatusBookState> {
  final BookingRepository repo;

  // Map لكل sessionId تتبع حالة اللودينج
  final Map<String, bool> loadingSessions = {};

  StatusBookBloc(this.repo) : super(StatusBookInitial()) {
    on<StatusBookSession>((event, emit) async {
      final id = event.id.toString();

      // نعلم أن الكارد ده بدأ اللودينج
      loadingSessions[id] = true;
      emit(StatusBookLoadingForSession(id: id)); // حالة جديدة لكل session

      try {
        final response = await repo.statusBookSession(event.id, event.request);

        loadingSessions[id] = false;

        switch (response) {
          case StatusBookingSuccess s:
            emit(StatusBookSuccess(success: s, sessionId: id));
            break;
          case StatusBookingFailure f:
            emit(StatusBookFailure(error: f.error, sessionId: id));
            break;
        }
      } catch (e) {
        loadingSessions[id] = false;
        emit(StatusBookFailure(
            error: StatusBookingErrorResponse(message: e.toString()),
            sessionId: id));
      }
    });
  }
}
