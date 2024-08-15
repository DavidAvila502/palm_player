import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/domain/use_cases/song_use_cases.dart';
import 'package:palm_player/presentation/cubits/player/player_cubit.dart';
import 'package:palm_player/presentation/cubits/player/player_state.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_cubit.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_state.dart';

class ExpandiblePlayerSamallContent extends StatefulWidget {
  final void Function() expandDraggableToMaxSize;
  const ExpandiblePlayerSamallContent(
      {super.key, required this.expandDraggableToMaxSize});

  @override
  State<ExpandiblePlayerSamallContent> createState() =>
      _ExpandiblePlayerSamallContentState();
}

class _ExpandiblePlayerSamallContentState
    extends State<ExpandiblePlayerSamallContent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 25,
              ),
              GestureDetector(
                onTap: () {
                  widget.expandDraggableToMaxSize();
                },
                child: const Icon(
                  Icons.arrow_drop_up,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              CircleAvatar(
                  child: ClipOval(
                child: BlocBuilder<GetSongArtcubit, GetSongArtState>(
                  bloc: GetSongArtcubit(context.read<SongUseCases>())
                    ..getSongArt(
                        context.read<PlayerCubit>().state.currentSong?.id),
                  builder: (context, state) {
                    if (state is GetSongArtStateLoaded) {
                      return state.albumArt != null
                          ? Image.memory(
                              state.albumArt!,
                              fit: BoxFit.contain,
                            )
                          : const Icon(Icons.image_not_supported);
                    }

                    if (state is GetSongArtStateLoading) {
                      return const CircularProgressIndicator();
                    } else {
                      return const Icon(Icons.image_not_supported);
                    }
                  },
                ),
              )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 5,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.watch<PlayerCubit>().state.currentSong?.name ??
                            'Unknown',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      ),
                      Text(
                        context
                                .watch<PlayerCubit>()
                                .state
                                .currentSong
                                ?.artist ??
                            'Unknown',
                        style: const TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.3)),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      )
                    ]),
              ),
              const Spacer(),
              BlocBuilder<PlayerCubit, PlayerState>(builder: (context, state) {
                if (state is PlayerStatePlaying) {
                  return GestureDetector(
                    onTap: () {
                      context.read<PlayerCubit>().pauseSog();
                    },
                    child: const Icon(
                      Icons.stop_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  );
                } else if (state is PlayerStatePaused) {
                  return GestureDetector(
                    onTap: () {
                      context.read<PlayerCubit>().resumeSong();
                    },
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 30,
                    ),
                  );
                } else {
                  return const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  );
                }
              }),
              const SizedBox(
                width: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
