import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/domain/use_cases/album_use_cases.dart';
import 'package:palm_player/presentation/cubits/album/get_album_art/get_album_art_state.dart';

class GetAlbumArtCubit extends Cubit<GetAlbumArtState> {
  final AlbumUseCases _albumUseCases;

  GetAlbumArtCubit(this._albumUseCases)
      : super(const GetAlbumArtStateInitial());

  Future<void> getAlbumArt(int id) async {
    if (state is! GetAlbumArtStateLoaded) {
      try {
        emit(const GetAlbumArtStateLoading());
        Uint8List? response = await _albumUseCases.getAlbumArt(id);

        emit(GetAlbumArtStateLoaded(response));
      } catch (_) {
        emit(const GetAlbumArtStateError('Error trying to load de album art.'));
      }
    }
  }
}
