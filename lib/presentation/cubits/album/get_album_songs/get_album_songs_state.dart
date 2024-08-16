import 'package:equatable/equatable.dart';
import 'package:palm_player/domain/entities/song.dart';

class GetAlbumSongsState extends Equatable {
  const GetAlbumSongsState();

  @override
  List<Object?> get props => [];
}

class GetAlbumSongsStateInitial extends GetAlbumSongsState {
  const GetAlbumSongsStateInitial();
}

class GetAlbumSongsStateLoading extends GetAlbumSongsState {
  const GetAlbumSongsStateLoading();
}

class GetAlbumSongsStateLoaded extends GetAlbumSongsState {
  final List<Song> songs;

  const GetAlbumSongsStateLoaded(this.songs);

  @override
  List<Object?> get props => [songs];
}

class GetAlbumSongsStateError extends GetAlbumSongsState {
  final String message;

  const GetAlbumSongsStateError(this.message);

  @override
  List<Object?> get props => [message];
}
