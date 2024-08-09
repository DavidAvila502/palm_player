import 'dart:typed_data';
import 'package:on_audio_query/on_audio_query.dart ' as audio_query;
import 'package:palm_player/data/datasources/local/song/song_local_datasource.dart';
import 'package:palm_player/data/models/song_model.dart';

class SongLocalDatasource2Imp extends SongLocalDatasource {
  final audio_query.OnAudioQuery _onAudioQuery = audio_query.OnAudioQuery();

  @override
  Future<List<SongModel>> getAllSongs() async {
    List<audio_query.SongModel> data = await _onAudioQuery.querySongs();

    List<SongModel> songs = data
        .map((currentSong) => SongModel(
              id: currentSong.id,
              albumId: currentSong.albumId,
              albumName: currentSong.album,
              filePath: currentSong.data,
              albumArtistName: currentSong.artist,
              trackNumber: currentSong.track,
              trackName: currentSong.title,
              albumArt: null,
              trackDuration: currentSong.duration,
            ))
        .toList();

    return songs;
  }

  @override
  Future<Uint8List?> getSongArt(int id) async {
    Uint8List? songArt =
        await _onAudioQuery.queryArtwork(id, audio_query.ArtworkType.AUDIO);

    return songArt;
  }
}
