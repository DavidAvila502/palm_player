import 'package:equatable/equatable.dart';
import 'song.dart';

class Album extends Equatable {
  final int id;
  final String? name;
  final String? artist;
  final int? year;
  final List<Song>? songs;

  const Album(
      {required this.id,
      required this.name,
      required this.artist,
      required this.year,
      required this.songs});

  @override
  List<Object?> get props => [name, artist, year, songs];
}
