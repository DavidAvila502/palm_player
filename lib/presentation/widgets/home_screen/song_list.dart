import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/domain/use_cases/song_use_cases.dart';
import 'package:palm_player/presentation/cubits/player/player_cubit.dart';
import 'package:palm_player/presentation/cubits/player/player_state.dart';
import 'package:palm_player/presentation/cubits/song/get_all_songs/get_all_songs_state.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_cubit.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_state.dart';

class SongList extends StatelessWidget {
  final GetAllSongsStateLoaded state;
  const SongList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(

        //* Divider
        separatorBuilder: (BuildContext context, index) {
          return const Divider(
            color: Color.fromRGBO(255, 255, 255, 0.1),
            height: 25,
          );
        },
        itemCount: state.songList.length,
        itemBuilder: (BuildContext context, int index) {
          //* Song list item
          return Row(children: <Widget>[
            // * Playing icon
            BlocBuilder<PlayerCubit, PlayerState>(builder: (context, state) {
              if (state is PlayerStatePlaying) {
                return state.currentSongPath ==
                        this.state.songList[index].reference!
                    ? Icon(Icons.equalizer,
                        color: Theme.of(context).primaryColor)
                    : const Icon(Icons.equalizer,
                        color: Color.fromRGBO(255, 255, 255, 0.2));
              }

              if (state is PlayerStatePaused) {
                return state.currentSongPath ==
                        this.state.songList[index].reference!
                    ? Icon(Icons.equalizer,
                        color: Theme.of(context).primaryColor)
                    : const Icon(Icons.equalizer,
                        color: Color.fromRGBO(255, 255, 255, 0.2));
              }

              return const Icon(Icons.equalizer,
                  color: Color.fromRGBO(255, 255, 255, 0.2));

              // return Container();
            }),

            const SizedBox(
              width: 10,
            ),

            //* Song image
            BlocBuilder<GetSongArtcubit, GetSongArtState>(
                bloc: GetSongArtcubit(context.read<SongUseCases>())
                  ..getSongArt(state.songList[index].id),
                builder: (context, state) {
                  if (state is GetSongArtStateLoading) {
                    return const ClipOval(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is GetSongArtStateLoaded) {
                    return ClipOval(
                        child: state.albumArt != null
                            ? Image.memory(
                                state.albumArt!,
                                height: 50,
                              )
                            : Container(
                                height: 50,
                                width: 50,
                                color: Colors.white,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 30,
                                ),
                              ));
                  } else {
                    return Container();
                  }
                }),
            const SizedBox(
              width: 10,
            ),

            // * Song title
            SizedBox(
              width: 200,
              child: GestureDetector(
                onTap: () {
                  context
                      .read<PlayerCubit>()
                      .playSong(state.songList[index].reference!);
                },
                child: Text(
                  state.songList[index].name ?? 'none',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                ),
              ),
            ),

            const Spacer(),

            // * Song duration

            Text(
              state.songList[index].duration?.toString() ?? 'unknown',
              style: const TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.3), fontSize: 12),
            )
          ]);
        });
  }
}
