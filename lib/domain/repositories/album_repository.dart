import 'dart:typed_data';

import 'package:palm_player/domain/entities/album.dart';
import 'package:palm_player/domain/entities/song.dart';

abstract class AlbumRepository {
  // Local datasources
  Future<List<Album>> getAlbums();

  Future<Uint8List?> getAlbumArt(int id);

  Future<List<Song>> getAlbumSongs(int id);
}
