abstract class TracksEvent {}

class LoadTracksEvent extends TracksEvent {}

class JoinTrackEvent extends TracksEvent {
  final String trackId;

  JoinTrackEvent(this.trackId);
}
<<<<<<< HEAD

class LeaveChatEvent extends TracksEvent {
  final String chatId;

  LeaveChatEvent(this.chatId);
}
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
