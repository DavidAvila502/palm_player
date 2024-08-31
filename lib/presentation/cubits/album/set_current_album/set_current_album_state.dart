import 'package:equatable/equatable.dart';
import 'package:palm_player/domain/entities/album.dart';

class SetCurrentAlbumState extends Equatable {
  const SetCurrentAlbumState();

  @override
  List<Object?> get props => [];
}

class SetCurrentAlbumStateInitial extends SetCurrentAlbumState {
  const SetCurrentAlbumStateInitial();
}

class SetCurrentAlbumStateLoading extends SetCurrentAlbumState {
  const SetCurrentAlbumStateLoading();
}

class SetCurrentAlbumStateLoaded extends SetCurrentAlbumState {
  final Album album;

  const SetCurrentAlbumStateLoaded({required this.album});

  @override
  List<Object?> get props => [album];
}

class SetCurrentAlbumStateError extends SetCurrentAlbumState {
  final String message;

  const SetCurrentAlbumStateError({required this.message});

  @override
  List<Object?> get props => [message];
}
