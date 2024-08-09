import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:palm_player/data/datasources/local/song/song_local_datasource_imp.dart';
import 'package:palm_player/data/datasources/local/song/song_local_datasource2_imp.dart';
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

  final SongUseCases _songUseCases = SongUseCases(
      SongRepositoryImp(songLocalDatasource: SongLocalDatasource2Imp()));

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
  }

  Future<void> clearTemporallyFiles() async {
    FilePicker.platform.clearTemporaryFiles();

    setState(() {
      songList = [];
    });
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
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: SizedBox(
                    height: 600,
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, index) {
                          return const SizedBox(
                            height: 15,
                          );
                        },
                        itemCount: songList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(children: <Widget>[
                            FutureBuilder(
                                future: _songUseCases
                                    .getSongArt(songList[index].id),
                                builder: (BuildContext context, snapShot) {
                                  return ClipOval(
                                      child: !snapShot.hasData
                                          ? const CircularProgressIndicator()
                                          : Image.memory(
                                              snapShot.data!,
                                              height: 50,
                                            ));
                                }),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                playAudio(songList[index]);
                              },
                              child: Text(songList[index].name ?? 'none'),
                            ),
                          ]);
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
