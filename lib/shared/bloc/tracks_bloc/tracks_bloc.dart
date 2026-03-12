import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/data/models/join_track/join_response.dart';
import 'package:skill_swap/shared/data/models/join_track/join_track_error_response.dart';

import '../../domain/repositories/chat_repository.dart';
import 'tracks_event.dart';
import 'tracks_state.dart';

class TracksBloc extends Bloc<TracksEvent, TracksState> {
  final ChatRepository repository;

  TracksBloc(this.repository) : super(JoinTracksInitial()) {
    on<LoadTracksEvent>(_loadTracks);
    on<JoinTrackEvent>(_joinTrack);
  }

  Future<void> _joinTrack(
      JoinTrackEvent event, Emitter<TracksState> emit) async {
    emit(JoinTracksLoading());

    final response = await repository.joinTrack(event.trackId);

    switch (response) {
      case JoinTrackSuccess s:
        emit(JoinTracksSuccess(success: s));
        break;

      case JoinTrackFailure f:
        emit(JoinTracksError(error: f));
        break;
    }
  }

  Future<void> _loadTracks(
      LoadTracksEvent event, Emitter<TracksState> emit) async {
    emit(JoinTracksLoading());

    try {
      final response = await repository.getTracks();
      emit(JoinTracksLoaded(response.tracks ?? []));
    } catch (e) {
      emit(JoinTracksError(
        error: JoinTrackFailure(
          JoinTrackErrorResponse(message: e.toString()),
        ),
      ));
    }
  }
}
