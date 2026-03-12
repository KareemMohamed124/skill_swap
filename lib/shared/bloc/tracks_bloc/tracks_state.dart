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
