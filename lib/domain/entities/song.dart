import 'dart:typed_data';
import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final int id;
  final int? albumId;
  final int? number;
  final String? name;
  final String? album;
  final int? duration;
  final Uint8List? image;
  final String? artist;
  final String? reference;

  const Song(
      {required this.id,
      required this.albumId,
      required this.number,
      required this.name,
      required this.album,
      required this.duration,
      required this.image,
      required this.artist,
      required this.reference});

  @override
  List<Object?> get props =>
      [id, albumId, number, name, album, duration, image, artist, reference];
}
