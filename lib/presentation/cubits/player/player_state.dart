import 'package:equatable/equatable.dart';

class PlayerState extends Equatable {
  const PlayerState();

  @override
  List<Object?> get props => [];
}

class PlayerStateInitial extends PlayerState {
  const PlayerStateInitial();
}

class PlayerStatePlaying extends PlayerState {
  final String currentSongPath;

  const PlayerStatePlaying(this.currentSongPath);
  @override
  List<Object?> get props => [currentSongPath];
}

class PlayerStatePaused extends PlayerState {
  final String currentSongPath;

  const PlayerStatePaused(this.currentSongPath);
  @override
  List<Object?> get props => [currentSongPath];
}

class PlayerStateStopped extends PlayerState {
  const PlayerStateStopped();
}

class PlayerStateError extends PlayerState {
  final String message;

  const PlayerStateError(this.message);

  @override
  List<Object?> get props => [message];
}
