import 'package:equatable/equatable.dart';
import 'package:palm_player/domain/entities/song.dart';

class GetAllSongsState extends Equatable {
  const GetAllSongsState();

  @override
  List<Object?> get props => [];
}

class GetAllSongsStateInitial extends GetAllSongsState {
  const GetAllSongsStateInitial();
}

class GetAllSongsStateLoading extends GetAllSongsState {
  const GetAllSongsStateLoading();
}

class GetAllSongsStateLoaded extends GetAllSongsState {
  final List<Song> songList;

  const GetAllSongsStateLoaded(this.songList);

  @override
  List<Object?> get props => [songList];
}

class GetAllSongsStateError extends GetAllSongsState {
  final String message;

  const GetAllSongsStateError(this.message);

  @override
  List<Object?> get props => [message];
}
