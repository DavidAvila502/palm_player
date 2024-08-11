import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class GetAlbumArtState extends Equatable {
  const GetAlbumArtState();

  @override
  List<Object?> get props => [];
}

class GetAlbumArtStateInitial extends GetAlbumArtState {
  const GetAlbumArtStateInitial();
}

class GetAlbumArtStateLoading extends GetAlbumArtState {
  const GetAlbumArtStateLoading();
}

class GetAlbumArtStateLoaded extends GetAlbumArtState {
  final Uint8List? albumArt;

  const GetAlbumArtStateLoaded(this.albumArt);

  @override
  List<Object?> get props => [albumArt];
}

class GetAlbumArtStateError extends GetAlbumArtState {
  final String message;

  const GetAlbumArtStateError(this.message);

  @override
  List<Object?> get props => [message];
}
