import 'package:equatable/equatable.dart';
import 'package:palm_player/domain/entities/song.dart';

enum PlayerStatus { initial, playing, paused, stopped, error, playListLoaded }

enum PlayMode {
  normal,
  repeatOne,
  repeatAll,
  shuffle,
}

class PlayerState extends Equatable {
  final Song? currentSong;
  final List<Song?> playList;
  final PlayerStatus status;
  final PlayMode playMode;
  final String? errorMessage;

  const PlayerState(
      {this.currentSong,
      this.playList = const [],
      required this.status,
      this.playMode = PlayMode.normal,
      this.errorMessage});

  PlayerState copyWith({
    Song? currentSong,
    List<Song?>? playList,
    PlayerStatus? status,
    PlayMode? playMode,
    String? errorMessage,
  }) {
    return PlayerState(
        currentSong: currentSong ?? this.currentSong,
        playList: playList ?? this.playList,
        status: status ?? this.status,
        playMode: playMode ?? this.playMode,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object?> get props => [currentSong, playList, status, playMode];
}
