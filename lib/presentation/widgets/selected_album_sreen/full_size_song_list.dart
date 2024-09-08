import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/domain/entities/song.dart';
import 'package:palm_player/presentation/cubits/player/player_cubit.dart';
import 'package:palm_player/presentation/cubits/player/player_state.dart';
import 'package:palm_player/presentation/utils/miliseconds_to_minutes.dart';

class FullSizeSongList extends StatelessWidget {
  final List<Song> songList;

  const FullSizeSongList({super.key, required this.songList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...songList.map((song) => GestureDetector(
              onTap: () {
                context.read<PlayerCubit>().setPlayList(songList);
                context.read<PlayerCubit>().playSong(song);
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      // * Playing icon
                      BlocBuilder<PlayerCubit, PlayerState>(
                          builder: (context, playerState) {
                        if (playerState.currentSong?.id == song.id) {
                          return Icon(
                            Icons.equalizer_rounded,
                            color: Theme.of(context).primaryColor,
                          );
                        } else {
                          return const Icon(
                            Icons.equalizer_rounded,
                            color: Color.fromRGBO(255, 255, 255, 0.2),
                          );
                        }
                      }),
                      const SizedBox(
                        width: 10,
                      ),

                      // * Song name
                      Expanded(
                        child: Text(
                          song.name ?? 'Unknown',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w200),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      // * Song duration
                      Text(
                        miliSecondsToMinutesFormat(song.duration),
                        style: const TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.3),
                            fontSize: 12),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 0.1,
                  )
                ],
              ),
            ))
      ],
    );
  }
}
