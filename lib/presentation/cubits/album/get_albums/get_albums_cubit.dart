import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/domain/entities/album.dart';
import 'package:palm_player/domain/use_cases/album_use_cases.dart';
import 'package:palm_player/presentation/cubits/album/get_albums/get_albums_state.dart';

class GetAlbumsCubit extends Cubit<GetAlbumsState> {
  final AlbumUseCases _albumUseCases;

  GetAlbumsCubit(this._albumUseCases) : super(const GetAlbumsStateInitial());

  Future<void> getAlbums() async {
    if (state is! GetAlbumsStateLoaded) {
      try {
        emit(const GetAlbumsStateLoading());
        List<Album> response = await _albumUseCases.getAlbums();

        emit(GetAlbumsStateLoaded(response));
      } catch (_) {
        emit(const GetAlbumsStateError('Error trying to load the albums.'));
      }
    }
  }
}
