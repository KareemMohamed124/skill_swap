import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skill_swap/shared/domain/repositories/booking_repository.dart';

import '../../data/models/booking/booking_request.dart';
import '../../data/models/booking/booking_response.dart';

part 'book_session_event.dart';

part 'book_session_state.dart';

class BookSessionBloc extends Bloc<BookSessionEvent, BookSessionState> {
  final BookingRepository repo;

  BookSessionBloc(this.repo) : super(BookSessionInitial()) {
    on<BookSession>((event, emit) async {
      emit(BookSessionLoading());

      final response = await repo.bookSession(event.request);

      switch (response) {
        case BookingSuccess s:
          emit(BookSessionSuccess(success: s));
          break;
        case BookingFailure f:
          emit(BookSessionFailure(error: f));
          break;
      }
    });
  }
}
