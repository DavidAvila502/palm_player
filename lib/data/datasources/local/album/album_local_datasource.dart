import 'dart:typed_data';

import 'package:palm_player/data/models/album_model.dart';
import 'package:palm_player/data/models/song_model.dart';

abstract class AlbumLocalDatasource {
  Future<List<AlbumModel>> getAlbums();

  Future<Uint8List?> getAlbumArt(int id);

  Future<List<SongModel>> getAlbumSongs(int id);
}
