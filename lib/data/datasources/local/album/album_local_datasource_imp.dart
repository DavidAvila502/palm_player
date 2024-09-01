import 'dart:typed_data';
import 'package:palm_player/data/datasources/local/album/album_local_datasource.dart';
import 'package:palm_player/data/models/album_model.dart';
import 'package:on_audio_query/on_audio_query.dart ' as audio_query;
import 'package:palm_player/data/models/song_model.dart';
import 'package:permission_handler/permission_handler.dart';

class AlbumLocalDatasourceImp extends AlbumLocalDatasource {
  final audio_query.OnAudioQuery _onAudioQuery = audio_query.OnAudioQuery();

  @override
  Future<List<AlbumModel>> getAlbums() async {
    if (!await Permission.audio.isGranted) {
      await Permission.audio.request();
    }

    if (!await Permission.audio.isGranted) {
      return [];
    }

    List<audio_query.AlbumModel> data = await _onAudioQuery.queryAlbums();

    List<AlbumModel> albums = data
        .map((currentAlbum) => AlbumModel(
            id: currentAlbum.id,
            albumName: currentAlbum.album,
            albumArtis: currentAlbum.artist,
            albumYear: null,
            songs: null))
        .toList();

    return albums;
  }

  @override
  Future<Uint8List?> getAlbumArt(int id) async {
    Uint8List? albumArt =
        await _onAudioQuery.queryArtwork(id, audio_query.ArtworkType.ALBUM);

    return albumArt;
  }

  @override
  Future<List<SongModel>> getAlbumSongs(int id) async {
    List<audio_query.SongModel> data = await _onAudioQuery.queryAudiosFrom(
        audio_query.AudiosFromType.ALBUM_ID, id);

    List<SongModel> songs = data
        .map((currentSong) => SongModel(
            id: currentSong.id,
            albumArt: null,
            albumArtistName: currentSong.artist,
            albumId: currentSong.albumId,
            albumName: currentSong.album,
            filePath: currentSong.data,
            trackDuration: currentSong.duration,
            trackName: currentSong.title,
            trackNumber: currentSong.track))
        .toList();

    return songs;
  }
}
