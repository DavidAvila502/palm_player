import 'dart:typed_data';
import 'package:palm_player/domain/entities/song.dart';

abstract class SongRepository {
  // Local datasources
  Future<List<Song>> getAllSongs();

  Future<Uint8List?> getSongArt(int id);
}
