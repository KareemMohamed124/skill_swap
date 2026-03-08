import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/chat_repository.dart';
import 'tracks_event.dart';
import 'tracks_state.dart';

class TracksBloc extends Bloc<TracksEvent, TracksState> {
  final ChatRepository repository;

  TracksBloc(this.repository) : super(TracksInitial()) {
    on<LoadTracksEvent>(_loadTracks);
    on<JoinTrackEvent>(_joinTrack);
  }

  Future<void> _loadTracks(
      LoadTracksEvent event, Emitter<TracksState> emit) async {
    emit(TracksLoading());

    try {
      final response = await repository.getTracks();
      emit(TracksLoaded(response.tracks ?? []));
    } catch (e) {
      emit(TracksError(e.toString()));
    }
  }

  Future<void> _joinTrack(
      JoinTrackEvent event, Emitter<TracksState> emit) async {
    try {
      final response = await repository.joinTrack(event.trackId);
      emit(JoinTrackSuccess(response.message ?? "Joined Successfully"));
    } catch (e) {
      emit(TracksError(e.toString()));
    }
  }
}
