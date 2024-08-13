import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' as audio_play;
import 'package:palm_player/domain/entities/song.dart';
import 'package:palm_player/presentation/cubits/player/player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  final audio_play.AudioPlayer _audioPlayer = audio_play.AudioPlayer();

  PlayerCubit() : super(PlayerStateInitial()) {
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == audio_play.ProcessingState.completed) {
        _nextPlayListSong();
      }
    });
  }

  void setPlayList(List<Song> playList, String? currentSongPath) {
    try {
      if (playList != state.playList) {
        emit(PlayerStatePlayListLoaded(currentSongPath, playList));
      }
    } catch (_) {
      emit(PlayerStateError('Error trying to set the Playlist.',
          state.currentSongPath, state.playList));
    }
  }

  Future<void> playSong(String path) async {
    try {
      await _audioPlayer.stop();
      emit(PlayerStateStopped(path, state.playList));
      await _audioPlayer.setFilePath(path);
      _audioPlayer.play();
      emit(PlayerStatePlaying(path, state.playList));
    } catch (_) {
      emit(PlayerStateError(
          'Error trying to play the song.', path, state.playList));
    }
  }

  Future<void> pauseSog(String path) async {
    try {
      await _audioPlayer.pause();
      emit(PlayerStatePaused(path, state.playList));
    } catch (_) {
      emit(PlayerStateError(
          'Error trying to pause the song.', path, state.playList));
    }
  }

  Future<void> resumeSong(String path) async {
    try {
      await _audioPlayer.play();
      emit(PlayerStatePlaying(path, state.playList));
    } catch (_) {
      emit(PlayerStateError(
          'Error trying to resume the song.', path, state.playList));
    }
  }

  void _nextPlayListSong() {
    final currentSongIndex = state.playList.indexWhere(
        (currentSong) => currentSong?.reference == state.currentSongPath);

    if (currentSongIndex >= 0 && currentSongIndex < state.playList.length - 1) {
      final nextSongReference = state.playList[currentSongIndex + 1]?.reference;

      if (nextSongReference != null) {
        playSong(nextSongReference);
      } else {
        emit(PlayerStateStopped(state.currentSongPath, state.playList));
      }
    }
  }
}
