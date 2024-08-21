class SongProgressState {
  final Duration position;
  final Duration duration;

  SongProgressState({
    required this.position,
    required this.duration,
  });

  SongProgressState copyWith({
    Duration? position,
    Duration? duration,
  }) {
    return SongProgressState(
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}
