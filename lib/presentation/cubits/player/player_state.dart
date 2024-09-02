import 'package:equatable/equatable.dart';
import 'package:palm_player/domain/entities/song.dart';

enum PlayerStatus { initial, playing, paused, stopped, error, playListLoaded }

enum PlayMode {
  normal,
  repeatOne,
  repeatAll,
}

class PlayerState extends Equatable {
  final Song? currentSong;
  final List<Song> playList;
  final PlayerStatus status;
  final PlayMode playMode;
  final bool isShuffle;
  final String? errorMessage;

  const PlayerState(
      {required this.status,
      this.currentSong,
      this.playList = const [],
      this.playMode = PlayMode.normal,
      this.isShuffle = false,
      this.errorMessage});

  PlayerState copyWith({
    Song? currentSong,
    List<Song>? playList,
    PlayerStatus? status,
    PlayMode? playMode,
    bool? isShuffle,
    String? errorMessage,
  }) {
    return PlayerState(
        currentSong: currentSong ?? this.currentSong,
        playList: playList ?? this.playList,
        status: status ?? this.status,
        playMode: playMode ?? this.playMode,
        isShuffle: isShuffle ?? this.isShuffle,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object?> get props =>
      [currentSong, playList, status, playMode, isShuffle, errorMessage];
}
