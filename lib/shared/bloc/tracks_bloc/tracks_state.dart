<<<<<<< HEAD
import '../../data/models/join_track/join_response.dart';
import '../../data/models/join_track/track_model.dart';

abstract class TracksState {}

class JoinTracksInitial extends TracksState {}

class JoinTracksLoading extends TracksState {}

class JoinTracksLoaded extends TracksState {
  final List<ListTracksModel> tracks;

  JoinTracksLoaded(this.tracks);
}

final class JoinTracksSuccess extends TracksState {
  final JoinTrackSuccess success;

  JoinTracksSuccess({required this.success});
}

final class JoinTracksError extends TracksState {
  final JoinTrackFailure error;

  JoinTracksError({required this.error});
}

class LeaveChatLoading extends TracksState {}

class LeaveChatSuccess extends TracksState {
  final String chatId;

  LeaveChatSuccess(this.chatId);
}

class LeaveChatError extends TracksState {
  final String message;

  LeaveChatError(this.message);
=======
import '../../data/models/public_chat/track_model.dart';

abstract class TracksState {}

class TracksInitial extends TracksState {}

class TracksLoading extends TracksState {}

class TracksLoaded extends TracksState {
  final List<ListTracksModel> tracks;

  TracksLoaded(this.tracks);
}

class TracksError extends TracksState {
  final String message;

  TracksError(this.message);
}

class JoinTrackSuccess extends TracksState {
  final String message;

  JoinTrackSuccess(this.message);
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
}
