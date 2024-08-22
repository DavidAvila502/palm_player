import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' as audio_play;
import 'package:palm_player/domain/entities/song.dart';
import 'package:palm_player/presentation/cubits/player/player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  final audio_play.AudioPlayer _audioPlayer;
  bool _isPlaySongLoading = false;
  final Random _random = Random();
  int _repeat = 1;

  PlayerCubit(this._audioPlayer)
      : super(const PlayerState(status: PlayerStatus.initial)) {
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == audio_play.ProcessingState.completed) {
        _autoPlayNextSongOnPlayList();
      }
    });
  }

  void setPlayList(List<Song> playList) {
    try {
      if (playList != state.playList) {
        emit(state.copyWith(
            status: PlayerStatus.playListLoaded, playList: playList));
      }
    } catch (_) {
      emit(state.copyWith(
          status: PlayerStatus.error,
          errorMessage: 'Error trying to set the PlayList.'));
    }
  }

  Future<void> playSong(Song currentSong, [int mightRepeatTimes = 1]) async {
    if (_isPlaySongLoading) return;
    _isPlaySongLoading = true;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setFilePath(currentSong.reference!);
      _isPlaySongLoading = false;
      _audioPlayer.play();
      _repeat = mightRepeatTimes;
      emit(state.copyWith(
          status: PlayerStatus.playing, currentSong: currentSong));
    } catch (_) {
      emit(state.copyWith(
          status: PlayerStatus.error,
          errorMessage: 'Error trying to play the song.'));

      _isPlaySongLoading = false;
    }
  }

  Future<void> pauseSog() async {
    try {
      if (_audioPlayer.playerState.playing) {
        await _audioPlayer.pause();
        emit(state.copyWith(status: PlayerStatus.paused));
      }
    } catch (_) {
      emit(state.copyWith(
          status: PlayerStatus.error,
          errorMessage: 'Error trying to pause the song.'));
    }
  }

  Future<void> resumeSong() async {
    try {
      if (_audioPlayer.playerState.playing == false) {
        emit(state.copyWith(status: PlayerStatus.playing));
        await _audioPlayer.play();
      }
    } catch (_) {
      emit(state.copyWith(
          status: PlayerStatus.error,
          errorMessage: 'Error trying to resume the song.'));
    }
  }

  bool playNextSongOnPlayList() {
    if (state.isShuffle) {
      return _playShuffleSong();
    }

    // get current song index in the playlist
    final currentSongIndex = state.playList
        .indexWhere((song) => song?.reference == state.currentSong?.reference!);

    // if there is a next song then play it
    if (currentSongIndex >= 0 && currentSongIndex < state.playList.length - 1) {
      final nextSong = state.playList[currentSongIndex + 1];

      if (nextSong != null) {
        playSong(nextSong);
        return true;
      } else {
        emit(state.copyWith(status: PlayerStatus.stopped));
        return false;
      }
    }

    return false;
  }

  bool playPreviousSongOnPlayList() {
    if (state.isShuffle) {
      return _playShuffleSong();
    }

    // get current song index in the playlist

    final currentSongIndex = state.playList.indexWhere((song) {
      return song?.id == state.currentSong?.id;
    });

    // if there is a prevous song then play it

    if (currentSongIndex > 0) {
      final previousSong = state.playList[currentSongIndex - 1];

      if (previousSong != null) {
        playSong(previousSong);
        return true;
      } else {
        emit(state.copyWith(status: PlayerStatus.stopped));
        return false;
      }
    }

    return false;
  }

  void changePlayerMode(PlayMode mode) {
    try {
      emit(state.copyWith(playMode: mode));
    } catch (_) {
      emit(state.copyWith(
          status: PlayerStatus.error,
          errorMessage: 'Error trying to change the player mode.'));
    }
  }

  void setShuffle(bool param) {
    try {
      emit(state.copyWith(isShuffle: param));
    } catch (_) {
      emit(state.copyWith(
          status: PlayerStatus.error,
          errorMessage: 'Error trying to set Shuffle mode'));
    }
  }

  bool _playShuffleSong() {
    final int randomSongIndex = _random.nextInt(state.playList.length - 1);

    final Song? randomSong = state.playList[randomSongIndex];

    if (randomSong != null) {
      playSong(randomSong);
      return true;
    }

    return false;
  }

  void _autoPlayNextSongOnPlayList() {
    if (state.playMode == PlayMode.repeatAll) {
      state.currentSong != null ? playSong(state.currentSong!) : null;
      return;
    } else if (state.playMode == PlayMode.repeatOne) {
      if (state.currentSong != null && _repeat > 0) {
        playSong(state.currentSong!, 0);
        return;
      }
    }

    if (state.isShuffle) {
      _playShuffleSong();
      return;
    }

    // get current song index in the playlist
    final currentSongIndex = state.playList
        .indexWhere((song) => song?.reference == state.currentSong?.reference!);

    // if there is a next song then play it
    if (currentSongIndex >= 0 && currentSongIndex < state.playList.length - 1) {
      final nextSong = state.playList[currentSongIndex + 1];

      if (nextSong != null) {
        playSong(nextSong);
      } else {
        emit(state.copyWith(status: PlayerStatus.stopped));
      }
    }
  }
}
