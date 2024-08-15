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

  void setPlayList(List<Song> playList, Song? currentSong) {
    try {
      if (playList != state.playList) {
        emit(PlayerStatePlayListLoaded(currentSong, playList));
      }
    } catch (_) {
      emit(PlayerStateError('Error trying to set the Playlist.',
          state.currentSong, state.playList));
    }
  }

  Future<void> playSong(Song currentSong) async {
    try {
      await _audioPlayer.stop();
      emit(PlayerStateStopped(currentSong, state.playList));
      await _audioPlayer.setFilePath(currentSong.reference!);
      _audioPlayer.play();
      emit(PlayerStatePlaying(currentSong, state.playList));
    } catch (_) {
      emit(PlayerStateError(
          'Error trying to play the song.', currentSong, state.playList));
    }
  }

  Future<void> pauseSog() async {
    try {
      if (_audioPlayer.playerState.playing) {
        await _audioPlayer.pause();
        emit(PlayerStatePaused(state.currentSong, state.playList));
      }
    } catch (_) {
      emit(PlayerStateError('Error trying to pause the song.',
          state.currentSong, state.playList));
    }
  }

  Future<void> resumeSong() async {
    try {
      if (_audioPlayer.playerState.playing == false) {
        emit(PlayerStatePlaying(state.currentSong, state.playList));
        await _audioPlayer.play();
      }
    } catch (_) {
      emit(PlayerStateError('Error trying to resume the song.',
          state.currentSong, state.playList));
    }
  }

  void _nextPlayListSong() {
    // get current song index in the playlist
    final currentSongIndex = state.playList
        .indexWhere((song) => song?.reference == state.currentSong!.reference!);

    // if there is a next song then play it
    if (currentSongIndex >= 0 && currentSongIndex < state.playList.length - 1) {
      final nextSong = state.playList[currentSongIndex + 1];

      if (nextSong != null) {
        playSong(nextSong);
      } else {
        emit(PlayerStateStopped(state.currentSong, state.playList));
      }
    }
  }
}
