import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/domain/use_cases/song_use_cases.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_state.dart';

class GetSongArtcubit extends Cubit<GetSongArtState> {
  final SongUseCases _songUseCases;

  GetSongArtcubit(this._songUseCases) : super(const GetSongArtStateInitial());

  Future<void> getSongArt(int? id) async {
    if (id == null) {
      return;
    }

    try {
      // if (state is! GetSongArtStateLoaded) {
      emit(const GetSongArtStateLoading());

      Uint8List? response = await _songUseCases.getSongArt(id);

      emit(GetSongArtStateLoaded(response));
      // }
    } catch (_) {
      // rethrow;
      emit(const GetSongArtStateError('Error trying to load the image.'));
    }
  }
}
