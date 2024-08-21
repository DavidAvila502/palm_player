import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palm_player/presentation/cubits/progress/song_progress_state.dart';

class SongProgressCubit extends Cubit<SongProgressState> {
  final AudioPlayer _audioPlayer;

  SongProgressCubit(this._audioPlayer)
      : super(SongProgressState(
          position: Duration.zero,
          duration: Duration.zero,
        )) {
    _audioPlayer.positionStream.listen((position) {
      emit(state.copyWith(position: position));
    });

    _audioPlayer.durationStream.listen((duration) {
      emit(state.copyWith(duration: duration ?? Duration.zero));
    });
  }

  void updateProgressTo(double param) {
    _audioPlayer.seek(Duration(seconds: param.toInt()));
  }
}
