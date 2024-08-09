import 'package:palm_player/data/models/song_model.dart';

abstract class SongLocalDatasource {
  Future<List<SongModel>> getAllSongs();
}
