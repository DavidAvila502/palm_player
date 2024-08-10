import 'dart:typed_data';
import 'package:palm_player/domain/entities/album.dart';
import 'package:palm_player/domain/entities/song.dart';
import 'package:palm_player/domain/repositories/album_repository.dart';

class AlbumUseCase {
  AlbumUseCase(this.albumRepository);

  final AlbumRepository albumRepository;

  Future<List<Album>> getAlbums() => albumRepository.getAlbums();

  Future<Uint8List?> getAlbumArt(int id) => albumRepository.getAlbumArt(id);

  Future<List<Song>> getAlbumSongs(int id) => albumRepository.getAlbumSongs(id);
}
