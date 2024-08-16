import 'dart:typed_data';
import 'package:palm_player/domain/entities/song.dart';
import 'package:palm_player/domain/repositories/song_repository.dart';

class SongUseCases {
  final SongRepository _songRepository;

  SongUseCases(this._songRepository);

  Future<List<Song>> getAllSongs() => _songRepository.getAllSongs();

  Future<Uint8List?> getSongArt(int id) => _songRepository.getSongArt(id);
}
