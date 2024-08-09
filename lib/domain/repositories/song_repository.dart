import 'package:palm_player/domain/entities/song.dart';

abstract class SongRepository {
  // Local datasources
  Future<List<Song>> getAllSongs();
}
