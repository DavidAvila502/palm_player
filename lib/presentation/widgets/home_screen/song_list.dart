import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/domain/entities/song.dart';
import 'package:palm_player/domain/use_cases/song_use_cases.dart';
import 'package:palm_player/presentation/cubits/player/player_cubit.dart';
import 'package:palm_player/presentation/cubits/player/player_state.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_cubit.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_state.dart';
import 'package:palm_player/presentation/utils/miliseconds_to_minutes.dart';

class SongList extends StatelessWidget {
  final List<Song> songs;
  const SongList({super.key, required this.songs});

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
        itemCount: songs.length,
        itemBuilder: (BuildContext context, int index) {
          //* Song list item
          return GestureDetector(
            onTap: () {
              context.read<PlayerCubit>().setPlayList(songs);
              context.read<PlayerCubit>().playSong(songs[index]);
            },
            child: Row(children: <Widget>[
              // * Playing icon
              BlocBuilder<PlayerCubit, PlayerState>(builder: (context, state) {
                if (state.currentSong?.reference == songs[index].reference) {
                  return Icon(Icons.equalizer,
                      color: Theme.of(context).primaryColor);
                } else {
                  return const Icon(Icons.equalizer,
                      color: Color.fromRGBO(255, 255, 255, 0.2));
                }
              }),

              const SizedBox(
                width: 10,
              ),

              //* Song image
              BlocBuilder<GetSongArtcubit, GetSongArtState>(
                  bloc: GetSongArtcubit(context.read<SongUseCases>())
                    ..getSongArt(songs[index].id),
                  builder: (context, state) {
                    if (state is GetSongArtStateLoading) {
                      return const SizedBox(
                        height: 50,
                        width: 50,
                        child: ClipOval(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is GetSongArtStateLoaded) {
                      return SizedBox(
                        height: 50,
                        width: 50,
                        child: ClipOval(
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
                                  )),
                      );
                    } else {
                      return Container();
                    }
                  }),
              const SizedBox(
                width: 10,
              ),

              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // * Song title

                    Text(
                      songs[index].name ?? 'none',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),

                    // * Song artist
                    Text(
                      songs[index].artist ?? 'Unknown',
                      style: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.4),
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // * Song duration

              Text(
                miliSecondsToMinutesFormat(songs[index].duration),
                style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.3), fontSize: 12),
              )
            ]),
          );
        });
  }
}
