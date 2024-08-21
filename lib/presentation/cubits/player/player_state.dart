import 'package:equatable/equatable.dart';
import 'package:palm_player/domain/entities/song.dart';

class PlayerState extends Equatable {
  final Song? currentSong;
  final List<Song?> playList;

  const PlayerState({
    required this.currentSong,
    required this.playList,
  });

  @override
  List<Object?> get props => [currentSong, playList];
}

class PlayerStateInitial extends PlayerState {
  PlayerStateInitial() : super(currentSong: null, playList: []);
}

class PlayerStatePlayListLoaded extends PlayerState {
  const PlayerStatePlayListLoaded(Song? currentSongPath, List<Song?> playList)
      : super(currentSong: currentSongPath, playList: playList);
}

class PlayerStatePlaying extends PlayerState {
  const PlayerStatePlaying(Song? currentSong, List<Song?> playList)
      : super(currentSong: currentSong, playList: playList);
}

class PlayerStatePaused extends PlayerState {
  const PlayerStatePaused(Song? currentSong, List<Song?> playList)
      : super(currentSong: currentSong, playList: playList);
}

class PlayerStateStopped extends PlayerState {
  const PlayerStateStopped(Song? currentSong, List<Song?> playList)
      : super(currentSong: currentSong, playList: playList);
}

class PlayerStateError extends PlayerState {
  final String message;

  const PlayerStateError(this.message, Song? currentSong, List<Song?> playList)
      : super(currentSong: currentSong, playList: playList);

  @override
  List<Object?> get props => [message];
}
