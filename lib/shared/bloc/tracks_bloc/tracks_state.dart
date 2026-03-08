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
}
