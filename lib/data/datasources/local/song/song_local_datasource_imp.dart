import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:palm_player/data/datasources/local/song/song_local_datasource.dart';
import 'package:palm_player/data/models/song_model.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class SongLocalDatasourceImp extends SongLocalDatasource {
  @override
  Future<List<SongModel>> getAllSongs() async {
    // Get permissions
    if (await Permission.audio.request().isGranted) {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        return [];
      }

      // get files
      final List<FileSystemEntity> files =
          await Directory(selectedDirectory).list(recursive: true).toList();

      // Filter mp3 files
      final List<FileSystemEntity> mp3Files = files.where((file) {
        return file is File && extension(file.path) == '.mp3';
      }).toList();

      // convert files to metaDataFiles
      final List<Metadata> metadataFiles =
          await Future.wait(mp3Files.map((mp3File) async {
        return await MetadataRetriever.fromFile(File(mp3File.path));
      }).toList());

      // Transform mp3 files in songModels
      final List<SongModel> songList = metadataFiles
          .map((currenFIle) => SongModel(
              id: currenFIle.hashCode,
              albumId: null,
              trackNumber: currenFIle.trackNumber,
              trackName: currenFIle.trackName,
              albumName: currenFIle.albumName,
              trackDuration: currenFIle.trackDuration,
              albumArt: currenFIle.albumArt,
              albumArtistName: currenFIle.albumArtistName,
              filePath: currenFIle.filePath))
          .toList();

      // print(metadataFiles.length);

      // throw UnimplementedError();

      return songList;
    }

    return [];
  }

  @override
  Future<Uint8List> getSongArt(int id) {
    // TODO: implement getSongArt
    throw UnimplementedError();
  }
}
