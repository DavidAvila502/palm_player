import 'dart:typed_data';
import 'package:equatable/equatable.dart';

class GetSongArtState extends Equatable {
  const GetSongArtState();

  @override
  List<Object?> get props => [];
}

class GetSongArtStateInitial extends GetSongArtState {
  const GetSongArtStateInitial();
}

class GetSongArtStateLoading extends GetSongArtState {
  const GetSongArtStateLoading();
}

class GetSongArtStateLoaded extends GetSongArtState {
  final Uint8List? albumArt;
  final int? songId;

  const GetSongArtStateLoaded(this.albumArt, this.songId);

  @override
  List<Object?> get props => [albumArt, songId];
}

class GetSongArtStateError extends GetSongArtState {
  final String message;

  const GetSongArtStateError(this.message);

  @override
  List<Object?> get props => [];
}
