import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< HEAD
import 'package:skill_swap/shared/data/models/join_track/join_response.dart';
import 'package:skill_swap/shared/data/models/join_track/join_track_error_response.dart';

import '../../data/models/join_track/track_model.dart';
=======

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import '../../domain/repositories/chat_repository.dart';
import 'tracks_event.dart';
import 'tracks_state.dart';

class TracksBloc extends Bloc<TracksEvent, TracksState> {
  final ChatRepository repository;

<<<<<<< HEAD
  List<ListTracksModel> _tracks = [];

  TracksBloc(this.repository) : super(JoinTracksInitial()) {
    on<LoadTracksEvent>(_loadTracks);
    on<JoinTrackEvent>(_joinTrack);
    on<LeaveChatEvent>(_leaveChat);
  }

  Future<void> _joinTrack(
      JoinTrackEvent event, Emitter<TracksState> emit) async {
    final response = await repository.joinTrack(event.trackId);

    switch (response) {
      case JoinTrackSuccess s:
        emit(JoinTracksSuccess(success: s));

        emit(JoinTracksLoaded(_tracks));
        break;

      case JoinTrackFailure f:
        emit(JoinTracksError(error: f));
        emit(JoinTracksLoaded(_tracks));
        break;
    }
  }

  Future<void> _leaveChat(
      LeaveChatEvent event, Emitter<TracksState> emit) async {
    try {
      await repository.leaveChat(event.chatId);

      emit(LeaveChatSuccess(event.chatId));

      emit(JoinTracksLoaded(_tracks));
    } catch (e) {
      emit(LeaveChatError(e.toString()));
      emit(JoinTracksLoaded(_tracks));
    }
=======
  TracksBloc(this.repository) : super(TracksInitial()) {
    on<LoadTracksEvent>(_loadTracks);
    on<JoinTrackEvent>(_joinTrack);
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  }

  Future<void> _loadTracks(
      LoadTracksEvent event, Emitter<TracksState> emit) async {
<<<<<<< HEAD
    emit(JoinTracksLoading());

    try {
      final response = await repository.getTracks();

      _tracks = response.tracks ?? [];

      emit(JoinTracksLoaded(_tracks));
    } catch (e) {
      emit(JoinTracksError(
        error: JoinTrackFailure(
          JoinTrackErrorResponse(message: e.toString()),
        ),
      ));
    }
  }
}
// class TracksBloc extends Bloc<TracksEvent, TracksState> {
//   final ChatRepository repository;
//
//   TracksBloc(this.repository) : super(JoinTracksInitial()) {
//     on<LoadTracksEvent>(_loadTracks);
//     on<JoinTrackEvent>(_joinTrack);
//     on<LeaveChatEvent>(_leaveChat);
//   }
//
//   Future<void> _joinTrack(
//       JoinTrackEvent event, Emitter<TracksState> emit) async {
//     emit(JoinTracksLoading());
//
//     final response = await repository.joinTrack(event.trackId);
//
//     switch (response) {
//       case JoinTrackSuccess s:
//         emit(JoinTracksSuccess(success: s));
//         break;
//
//       case JoinTrackFailure f:
//         emit(JoinTracksError(error: f));
//         break;
//     }
//   }
//
//   Future<void> _leaveChat(
//       LeaveChatEvent event, Emitter<TracksState> emit) async {
//     emit(LeaveChatLoading());
//
//     try {
//       await repository.leaveChat(event.chatId);
//       emit(LeaveChatSuccess(event.chatId));
//     } catch (e) {
//       emit(LeaveChatError(e.toString()));
//     }
//   }
//
//   Future<void> _loadTracks(
//       LoadTracksEvent event, Emitter<TracksState> emit) async {
//     emit(JoinTracksLoading());
//
//     try {
//       final response = await repository.getTracks();
//       emit(JoinTracksLoaded(response.tracks ?? []));
//     } catch (e) {
//       emit(JoinTracksError(
//         error: JoinTrackFailure(
//           JoinTrackErrorResponse(message: e.toString()),
//         ),
//       ));
//     }
//   }
// }
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
