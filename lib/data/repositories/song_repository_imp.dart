import 'package:palm_player/data/datasources/local/song/song_local_datasource.dart';
import 'package:palm_player/data/models/song_model.dart';
import 'package:palm_player/domain/entities/song.dart';
import 'package:palm_player/domain/repositories/song_repository.dart';

class SongRepositoryImp extends SongRepository {
  SongRepositoryImp({required this.songLocalDatasource});

  final SongLocalDatasource songLocalDatasource;

  @override
  Future<List<Song>> getAllSongs() async {
    List<SongModel> response = await songLocalDatasource.getAllSongs();

    return response.map((sonModel) => sonModel.toEntity()).toList();
  }
}
