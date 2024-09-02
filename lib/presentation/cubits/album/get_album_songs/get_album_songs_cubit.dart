import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/domain/entities/song.dart';
import 'package:palm_player/domain/use_cases/album_use_cases.dart';
import 'package:palm_player/presentation/cubits/album/get_album_songs/get_album_songs_state.dart';

class GetAlbumSongsCubit extends Cubit<GetAlbumSongsState> {
  final AlbumUseCases _albumUseCases;

  GetAlbumSongsCubit(this._albumUseCases)
      : super(const GetAlbumSongsStateInitial());

  Future<void> getAlbumSongs(int id) async {
    try {
      emit(const GetAlbumSongsStateLoading());

      List<Song> response = await _albumUseCases.getAlbumSongs(id);

      emit(GetAlbumSongsStateLoaded(response));
    } catch (_) {
      emit(const GetAlbumSongsStateError('Error trying to load the songs.'));
    }
  }
}
