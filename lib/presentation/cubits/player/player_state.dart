import 'package:equatable/equatable.dart';
import 'package:palm_player/domain/entities/song.dart';

class PlayerState extends Equatable {
  final String? currentSongPath;

  final List<Song?> playList;

  const PlayerState({
    required this.currentSongPath,
    required this.playList,
  });

  @override
  List<Object?> get props => [currentSongPath, playList];
}

class PlayerStateInitial extends PlayerState {
  PlayerStateInitial() : super(currentSongPath: null, playList: []);
}

class PlayerStatePlayListLoaded extends PlayerState {
  const PlayerStatePlayListLoaded(String? currentSongPath, List<Song?> playList)
      : super(currentSongPath: currentSongPath, playList: playList);
}

class PlayerStatePlaying extends PlayerState {
  const PlayerStatePlaying(String? currentSongPath, List<Song?> playList)
      : super(currentSongPath: currentSongPath, playList: playList);
}

class PlayerStatePaused extends PlayerState {
  const PlayerStatePaused(String? currentSongPath, List<Song?> playList)
      : super(currentSongPath: currentSongPath, playList: playList);
}

class PlayerStateStopped extends PlayerState {
  const PlayerStateStopped(String? currentSongPath, List<Song?> playList)
      : super(currentSongPath: currentSongPath, playList: playList);
}

class PlayerStateError extends PlayerState {
  final String message;

  const PlayerStateError(
      this.message, String? currentSongPath, List<Song?> playList)
      : super(currentSongPath: currentSongPath, playList: playList);

  @override
  List<Object?> get props => [message];
}
