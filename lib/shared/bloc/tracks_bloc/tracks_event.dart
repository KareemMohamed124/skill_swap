abstract class TracksEvent {}

class LoadTracksEvent extends TracksEvent {}

class JoinTrackEvent extends TracksEvent {
  final String trackId;

  JoinTrackEvent(this.trackId);
}
