part of 'cancel_book_bloc.dart';

@immutable
sealed class CancelBookEvent {}

class CancelBookSession extends CancelBookEvent {
  final String id;
<<<<<<< HEAD
  final String? recipientId;

  CancelBookSession({required this.id, this.recipientId});
=======

  CancelBookSession({required this.id});
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
}
