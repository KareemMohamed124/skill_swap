abstract class PrivateChatEvent {}

class GetPrivateChatsEvent extends PrivateChatEvent {}

class ChatListUpdateEvent extends PrivateChatEvent {
  final Map<String, dynamic> data;

  ChatListUpdateEvent(this.data);
}
