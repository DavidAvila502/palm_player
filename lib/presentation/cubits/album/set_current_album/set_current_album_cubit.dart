import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/domain/entities/album.dart';
import 'package:palm_player/presentation/cubits/album/set_current_album/set_current_album_state.dart';

class SetCurrentAlbumCubit extends Cubit<SetCurrentAlbumState> {
  SetCurrentAlbumCubit() : super(const SetCurrentAlbumStateInitial());

  void setCurrentAlbum(Album album) {
    try {
      emit(const SetCurrentAlbumStateLoading());

      emit(SetCurrentAlbumStateLoaded(album: album));
    } catch (_) {
      emit(const SetCurrentAlbumStateError(
          message: 'Something was wrong triying to set the current album.'));
    }
  }
}
