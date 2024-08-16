import 'dart:typed_data';
import 'package:palm_player/data/datasources/local/album/album_local_datasource.dart';
import 'package:palm_player/data/models/album_model.dart';
import 'package:palm_player/data/models/song_model.dart';
import 'package:palm_player/domain/entities/album.dart';
import 'package:palm_player/domain/entities/song.dart';
import 'package:palm_player/domain/repositories/album_repository.dart';

class AlbumRepositoryImp extends AlbumRepository {
  final AlbumLocalDatasource albumLocalDatasource;

  AlbumRepositoryImp({required this.albumLocalDatasource});

  @override
  Future<Uint8List?> getAlbumArt(int id) async {
    Uint8List? albumArt = await albumLocalDatasource.getAlbumArt(id);

    return albumArt;
  }

  @override
  Future<List<Album>> getAlbums() async {
    List<AlbumModel> response = await albumLocalDatasource.getAlbums();

    List<Album> albumList =
        response.map((currentAlbum) => currentAlbum.toEntity()).toList();

    return albumList;
  }

  @override
  Future<List<Song>> getAlbumSongs(int id) async {
    List<SongModel> response = await albumLocalDatasource.getAlbumSongs(id);

    List<Song> songs =
        response.map((currentSong) => currentSong.toEntity()).toList();

    return songs;
  }
}
