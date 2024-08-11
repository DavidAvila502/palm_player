import 'package:equatable/equatable.dart';
import 'package:palm_player/domain/entities/album.dart';

class GetAlbumsState extends Equatable {
  const GetAlbumsState();

  @override
  List<Object?> get props => [];
}

class GetAlbumsStateInitial extends GetAlbumsState {
  const GetAlbumsStateInitial();
}

class GetAlbumsStateLoading extends GetAlbumsState {
  const GetAlbumsStateLoading();
}

class GetAlbumsStateLoaded extends GetAlbumsState {
  final List<Album> albums;

  const GetAlbumsStateLoaded(this.albums);

  @override
  List<Object?> get props => [albums];
}

class GetAlbumsStateError extends GetAlbumsState {
  final String message;

  const GetAlbumsStateError(this.message);

  @override
  List<Object?> get props => [message];
}
