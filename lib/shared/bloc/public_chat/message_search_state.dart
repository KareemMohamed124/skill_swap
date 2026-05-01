import 'package:equatable/equatable.dart';
import '../../data/models/public_chat/get_history_messages.dart';

abstract class MessageSearchState extends Equatable {
  const MessageSearchState();

  @override
  List<Object?> get props => [];
}

class MessageSearchInitial extends MessageSearchState {}

class MessageSearchLoading extends MessageSearchState {}

class MessageSearchLoaded extends MessageSearchState {
  final List<ChatMessage> results;
  final String query;

  const MessageSearchLoaded({required this.results, required this.query});

  @override
  List<Object?> get props => [results, query];
}

class MessageSearchError extends MessageSearchState {
  final String message;

  const MessageSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
