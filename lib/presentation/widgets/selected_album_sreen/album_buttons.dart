import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/domain/entities/song.dart';
import 'package:palm_player/presentation/cubits/player/player_cubit.dart';
import 'package:palm_player/presentation/cubits/player/player_state.dart';

class AlbumButtons extends StatelessWidget {
  final List<Song> albumSongs;

  const AlbumButtons({super.key, required this.albumSongs});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // * Play button
        GestureDetector(
          onTap: () {
            if (albumSongs.isEmpty) {
              return;
            }
            context.read<PlayerCubit>().setPlayList(albumSongs);

            context.read<PlayerCubit>().playSong(albumSongs[0]);
          },
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  color: Theme.of(context).primaryColor),
              child: const Row(
                children: [
                  Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                  Text(
                    'Play',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              )),
        ),
        const SizedBox(
          width: 20,
        ),

        // * Shuffle button
        BlocBuilder<PlayerCubit, PlayerState>(
            builder: (BuildContext context, state) {
          if (state.isShuffle == true) {
            return GestureDetector(
              onTap: () {
                context.read<PlayerCubit>().setShuffle(false);
              },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: Theme.of(context)
                          .colorScheme
                          .onSecondaryFixedVariant),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.shuffle,
                        color: Colors.white,
                      ),
                      Text(
                        'Shuffle',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  )),
            );
          }
          return GestureDetector(
            onTap: () {
              context.read<PlayerCubit>().setShuffle(true);
            },
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: const Color.fromRGBO(255, 255, 255, 0.07)),
                child: const Row(
                  children: [
                    Icon(
                      Icons.shuffle,
                      color: Colors.white,
                    ),
                    Text(
                      'Shuffle',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                )),
          );
        })
      ],
    );
  }
}
