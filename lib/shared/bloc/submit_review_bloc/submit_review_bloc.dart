import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/submit_review/submit_review_error_response.dart';
import '../../data/models/submit_review/submit_review_request.dart';
import '../../data/models/submit_review/submit_review_response.dart';
<<<<<<< HEAD
import '../../domain/repositories/booking_repository.dart';

part 'submit_review_event.dart';
=======
import '../../data/models/submit_review/submit_review_success_response.dart';
import '../../domain/repositories/booking_repository.dart';

part 'submit_review_event.dart';

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
part 'submit_review_state.dart';

class SubmitReviewBloc extends Bloc<SubmitReviewEvent, SubmitReviewState> {
  final BookingRepository repository;

  SubmitReviewBloc(this.repository) : super(SubmitReviewInitial()) {
    on<ConfirmSubmit>((event, emit) async {
      emit(SubmitReviewLoading());

<<<<<<< HEAD
      try {
        final result = await repository.submitReview(event.id, event.request);

        if (result is SubmitReviewSuccess) {
          emit(SubmitReviewSuccessState("success"));
        } else if (result is SubmitReviewFailure) {
          emit(SubmitReviewFailureState(result.error));
        }
      } catch (e) {
        emit(SubmitReviewFailureState(
          SubmitReviewErrorResponse(message: e.toString()),
        ));
=======
      final result = await repository.submitReview(event.id, event.request);

      switch (result) {
        case SubmitReviewSuccess s:
          emit(SubmitReviewSuccessState(s.success));
          break;
        case SubmitReviewFailure f:
          emit(SubmitReviewFailureState(f.error));
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
      }
    });
  }
}
