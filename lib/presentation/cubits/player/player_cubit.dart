import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' as audio_play;
// import 'package:palm_player/domain/entities/song.dart';
import 'package:palm_player/presentation/cubits/player/player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  final audio_play.AudioPlayer _audioPlayer = audio_play.AudioPlayer();

  PlayerCubit() : super(const PlayerStateInitial());

  Future<void> playSong(String path) async {
    try {
      await _audioPlayer.stop();
      emit(const PlayerStateStopped());
      await _audioPlayer.setFilePath(path);
      _audioPlayer.play();
      emit(PlayerStatePlaying(path));
    } catch (_) {
      emit(const PlayerStateError('Error trying to play the song.'));
    }
  }

  Future<void> pauseSog(String path) async {
    try {
      await _audioPlayer.pause();
      emit(PlayerStatePaused(path));
    } catch (_) {
      emit(const PlayerStateError('Error trying to pause the song.'));
    }
  }

  Future<void> resumeSong(String path) async {
    try {
      await _audioPlayer.play();
      emit(PlayerStatePlaying(path));
    } catch (_) {
      emit(const PlayerStateError('Error trying to resume the song.'));
    }
  }
}
