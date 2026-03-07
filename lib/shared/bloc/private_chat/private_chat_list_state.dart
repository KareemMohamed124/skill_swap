import 'package:equatable/equatable.dart';

import '../../data/models/chat/chat_models.dart';

abstract class PrivateChatListState extends Equatable {
  const PrivateChatListState();

  @override
  List<Object?> get props => [];
}

class PrivateChatListInitial extends PrivateChatListState {}

class PrivateChatListLoading extends PrivateChatListState {}

class PrivateChatListLoaded extends PrivateChatListState {
  final List<PrivateChatModel> chats;
  final int totalUnread;

  const PrivateChatListLoaded({required this.chats, this.totalUnread = 0});

  @override
  List<Object?> get props => [chats, totalUnread];
}

class PrivateChatListError extends PrivateChatListState {
  final String message;

  const PrivateChatListError({required this.message});

  @override
  List<Object?> get props => [message];
}
