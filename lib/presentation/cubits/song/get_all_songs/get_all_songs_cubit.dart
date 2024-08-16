import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/domain/entities/song.dart';
import 'package:palm_player/domain/use_cases/song_use_cases.dart';
import 'package:palm_player/presentation/cubits/song/get_all_songs/get_all_songs_state.dart';

class GetAllSongsCubit extends Cubit<GetAllSongsState> {
  final SongUseCases _songUseCases;

  GetAllSongsCubit(this._songUseCases) : super(const GetAllSongsStateInitial());

  Future<void> getAllSongs() async {
    if (state is! GetAllSongsStateLoaded) {
      try {
        emit(const GetAllSongsStateLoading());

        List<Song> response = await _songUseCases.getAllSongs();

        emit(GetAllSongsStateLoaded(response));
      } catch (_) {
        // rethrow;

        emit(const GetAllSongsStateError('Error trying to load the songs.'));
      }
    }
  }
}
