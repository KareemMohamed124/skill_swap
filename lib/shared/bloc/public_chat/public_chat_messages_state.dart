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
  final ChatMessage? replyMessage;

  const PublicChatMessagesLoaded({
    required this.messages,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.replyMessage,
  });

  @override
  List<Object?> get props => [messages, hasMore, isLoadingMore, replyMessage];

  /// Copy with for pagination / loading more
  PublicChatMessagesLoaded copyWith({
    List<ChatMessage>? messages,
    bool? hasMore,
    bool? isLoadingMore,
    ChatMessage? replyMessage,
    bool clearReply = false,
  }) {
    return PublicChatMessagesLoaded(
      messages: messages ?? List.from(this.messages),
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      replyMessage: clearReply ? null : (replyMessage ?? this.replyMessage),
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
