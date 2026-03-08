part of 'submit_review_bloc.dart';

@immutable
sealed class SubmitReviewEvent {}

class ConfirmSubmit extends SubmitReviewEvent {
  final String id;
  final SubmitReviewRequest request;

  ConfirmSubmit({required this.id, required this.request});
}
