import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:palm_player/data/datasources/mappers/entity_convertible.dart';
import 'package:palm_player/domain/entities/song.dart';

class SongModel extends Equatable with EntityConvertible<SongModel, Song> {
  final int? trackNumber;
  final String? trackName;
  final String? albumName;
  final int? trackDuration;
  final Uint8List? albumArt;
  final String? albumArtistName;
  final String? filePath;

  const SongModel(
      {required this.trackNumber,
      required this.trackName,
      required this.albumName,
      required this.trackDuration,
      required this.albumArt,
      required this.albumArtistName,
      required this.filePath});

  @override
  List<Object?> get props => [
        trackNumber,
        trackName,
        albumName,
        trackDuration,
        albumArt,
        albumArtistName,
        filePath
      ];

  @override
  Song toEntity() {
    return Song(
        number: trackNumber,
        name: trackName,
        album: albumName,
        duration: trackDuration,
        image: albumArt,
        artist: albumArtistName,
        reference: filePath);
  }

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
        trackNumber: json['trackNumber'],
        trackName: json['trackName'],
        albumName: json['albumName'],
        trackDuration: json['trackDuration'],
        albumArt: json['albumArt'],
        albumArtistName: json['albumArtistName'],
        filePath: json['filePath']);
  }

  Map<String, dynamic> toJson(SongModel song) {
    return {
      'trackNumber': trackNumber,
      'trackName': trackName,
      'albumName': albumName,
      'trackDuration': trackDuration,
      'albumArt': albumArt,
      'albumArtistName': albumArtistName,
      'filePath': filePath
    };
  }

  @override
  SongModel toModel() {
    // TODO: implement toModel
    throw UnimplementedError();
  }
}
