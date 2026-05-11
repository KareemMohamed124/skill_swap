import 'package:equatable/equatable.dart';

import '../../data/models/chat/chat_models.dart';

abstract class PrivateChatMessagesState extends Equatable {
  const PrivateChatMessagesState();

  @override
  List<Object?> get props => [];
}

class PrivateChatMessagesInitial extends PrivateChatMessagesState {}

class PrivateChatMessagesLoading extends PrivateChatMessagesState {}

class PrivateChatMessagesLoaded extends PrivateChatMessagesState {
  final List<ChatMessageModel> messages;
  final bool hasMore;
  final bool isLoadingMore;

  const PrivateChatMessagesLoaded({
    required this.messages,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [messages, hasMore, isLoadingMore];

  PrivateChatMessagesLoaded copyWith({
    List<ChatMessageModel>? messages,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PrivateChatMessagesLoaded(
      messages: messages ?? this.messages,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class PrivateChatMessagesError extends PrivateChatMessagesState {
  final String message;

  const PrivateChatMessagesError({required this.message});

  @override
  List<Object?> get props => [message];
}
