import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palm_player/data/datasources/local/song/song_local_datasorce_imp.dart';
import 'package:palm_player/data/repositories/song_repository_imp.dart';
import 'package:palm_player/domain/entities/song.dart';
import 'package:palm_player/domain/use_cases/song_use_cases.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Song> songList = [];
  AudioPlayer player = AudioPlayer();
  Uint8List? albumImage;

  final SongUseCases _songUseCases = SongUseCases(
      SongRepositoryImp(songLocalDatasource: SongLocalDatasorceImp()));

  Future<void> getAllSongs() async {
    List<Song> newSongList = await _songUseCases.getAllSongs();

    setState(() {
      songList = newSongList;
    });
  }

  Future<void> playAudio(Song song) async {
    if (song.reference == null) {
      return;
    }

    player.stop();
    player.setFilePath(song.reference!);
    player.play();

    setState(() {
      albumImage = song.image;
    });
  }

  Future<void> clearTemporallyFiles() async {
    FilePicker.platform.clearTemporaryFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Home screen'),
                ElevatedButton(
                    onPressed: () {
                      getAllSongs();
                    },
                    child: const Text('Pick songs')),
                ElevatedButton(
                    onPressed: () {
                      clearTemporallyFiles();
                    },
                    child: const Text('Clear')),
                SizedBox(
                  height: 600,
                  child: ListView.separated(
                      separatorBuilder: (BuildContext context, index) {
                        return const SizedBox(
                          height: 15,
                        );
                      },
                      itemCount: songList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            playAudio(songList[index]);
                          },
                          child: Text(songList[index].reference ?? 'none'),
                        );
                      }),
                ),
                albumImage != null
                    ? ClipOval(
                        child: Image.memory(
                        albumImage!,
                        fit: BoxFit.cover,
                        height: 300,
                      ))
                    : const Text('Empty')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
