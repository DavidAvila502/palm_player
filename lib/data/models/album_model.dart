import 'package:equatable/equatable.dart';
import 'package:palm_player/data/datasources/mappers/entity_convertible.dart';
import 'package:palm_player/domain/entities/album.dart';
import 'package:palm_player/domain/entities/song.dart';

class AlbumModel extends Equatable with EntityConvertible<AlbumModel, Album> {
  final int id;
  final String? albumName;
  final String? albumArtis;
  final int? albumYear;
  final List<Song>? songs;

  const AlbumModel(
      {required this.id,
      required this.albumName,
      required this.albumArtis,
      required this.albumYear,
      required this.songs});

  @override
  List<Object?> get props => [id, albumName, albumArtis, albumYear];

  @override
  Album toEntity() {
    return Album(
        id: id,
        name: albumName,
        artist: albumArtis,
        year: albumYear,
        songs: songs);
  }
}
