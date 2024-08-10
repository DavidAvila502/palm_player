import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palm_player/data/datasources/local/song/song_local_datasource2_imp.dart';
import 'package:palm_player/data/repositories/song_repository_imp.dart';
import 'package:palm_player/domain/entities/song.dart';
import 'package:palm_player/domain/use_cases/song_use_cases.dart';
import 'package:palm_player/presentation/cubits/song/get_all_songs/get_all_songs_cubit.dart';
import 'package:palm_player/presentation/cubits/song/get_all_songs/get_all_songs_state.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_cubit.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AudioPlayer player = AudioPlayer();

  final SongUseCases _songUseCases = SongUseCases(
      SongRepositoryImp(songLocalDatasource: SongLocalDatasource2Imp()));

  Future<void> playAudio(Song song) async {
    if (song.reference == null) {
      return;
    }

    player.stop();
    player.setFilePath(song.reference!);
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GetAllSongsCubit(_songUseCases),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Home screen'),
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                          onPressed: () {
                            final cubit = context.read<GetAllSongsCubit>();
                            cubit.getAllSongs();
                          },
                          child: const Text('Pick songs'));
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // clearTemporallyFiles();
                      },
                      child: const Text('Clear')),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: SizedBox(
                      height: 600,
                      child: BlocBuilder<GetAllSongsCubit, GetAllSongsState>(
                        builder: (context, state) {
                          if (state is GetAllSongsStateLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is GetAllSongsStateLoaded) {
                            return ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, index) {
                                  return const SizedBox(
                                    height: 15,
                                  );
                                },
                                itemCount: state.songList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(children: <Widget>[
                                    BlocBuilder<GetSongArtcubit,
                                            GetSongArtState>(
                                        bloc: GetSongArtcubit(_songUseCases)
                                          ..getAlbumrt(
                                              state.songList[index].id),
                                        builder: (context, state) {
                                          if (state is GetSongArtStateLoading) {
                                            return const ClipOval(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (state
                                              is GetSongArtStateLoaded) {
                                            return ClipOval(
                                                child: state.albumArt != null
                                                    ? Image.memory(
                                                        state.albumArt!,
                                                        height: 50,
                                                      )
                                                    : const Icon(Icons
                                                        .image_not_supported));
                                          } else {
                                            return Container();
                                          }
                                        }),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        playAudio(state.songList[index]);
                                      },
                                      child: Text(
                                          state.songList[index].name ?? 'none'),
                                    ),
                                  ]);
                                });
                          } else {
                            return const Text('Nothing to show.');
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
