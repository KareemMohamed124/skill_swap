import 'package:equatable/equatable.dart';

import '../../data/models/public_chat/get_history_messages.dart';

abstract class PublicChatMessagesState extends Equatable {
  const PublicChatMessagesState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class PublicChatMessagesInitial extends PublicChatMessagesState {}

/// Loading first page
class PublicChatMessagesLoading extends PublicChatMessagesState {}

/// Loaded state with messages
class PublicChatMessagesLoaded extends PublicChatMessagesState {
  final List<ChatMessage> messages;
  final bool hasMore;
  final bool isLoadingMore;

  const PublicChatMessagesLoaded({
    required this.messages,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [messages, hasMore, isLoadingMore];

  /// Copy with for pagination / loading more
  PublicChatMessagesLoaded copyWith({
    List<ChatMessage>? messages,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PublicChatMessagesLoaded(
      messages: messages ?? this.messages,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Error state
class PublicChatMessagesError extends PublicChatMessagesState {
  final String message;

  const PublicChatMessagesError({required this.message});

  @override
  List<Object?> get props => [message];
}
