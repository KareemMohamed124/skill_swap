part of 'submit_review_bloc.dart';

@immutable
<<<<<<< HEAD
abstract class SubmitReviewEvent {}

// submit normal review
=======
sealed class SubmitReviewEvent {}

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
class ConfirmSubmit extends SubmitReviewEvent {
  final String id;
  final SubmitReviewRequest request;

<<<<<<< HEAD
  ConfirmSubmit({
    required this.id,
    required this.request,
  });
=======
  ConfirmSubmit({required this.id, required this.request});
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
}
