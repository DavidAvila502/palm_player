import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/presentation/cubits/player/player_cubit.dart';
import 'package:palm_player/presentation/cubits/player/player_state.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_cubit.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_state.dart';

class ExpandiblePlayerSamallContent extends StatefulWidget {
  final void Function() expandDraggableToMaxSize;
  final bool isRotating;
  final void Function(bool) setIsRotating;

  const ExpandiblePlayerSamallContent(
      {super.key,
      required this.expandDraggableToMaxSize,
      required this.setIsRotating,
      this.isRotating = false});

  @override
  State<ExpandiblePlayerSamallContent> createState() =>
      _ExpandiblePlayerSamallContentState();
}

class _ExpandiblePlayerSamallContentState
    extends State<ExpandiblePlayerSamallContent>
    with SingleTickerProviderStateMixin {
  Uint8List? _imageCached;
  late AnimationController _animateRotateController;

  void _stopRotation() {
    _animateRotateController.stop();
  }

  void _playRotation() {
    _animateRotateController.repeat();
  }

  @override
  void initState() {
    super.initState();
    _animateRotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    widget.isRotating
        ? _animateRotateController.repeat()
        : _animateRotateController.stop();
  }

  @override
  void dispose() {
    _animateRotateController.dispose();
    super.dispose();
  }

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

              // * UP ARROW ICON *******

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

              // * SONG IMAGE ************

              RotationTransition(
                turns: _animateRotateController,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 0.5)),
                  child: CircleAvatar(
                    child: ClipOval(
                      child: BlocBuilder<GetSongArtcubit, GetSongArtState>(
                          builder: (context, state) {
                        return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,
                            child: (state is GetSongArtStateLoaded &&
                                    state.albumArt != null)
                                ? Image.memory(state.albumArt!,
                                    fit: BoxFit.contain,
                                    key: ValueKey(state.albumArt))
                                : (_imageCached != null)
                                    ? Image.memory(_imageCached!,
                                        fit: BoxFit.contain,
                                        key: ValueKey(_imageCached))
                                    : const Icon(
                                        Icons.image_not_supported,
                                        key: ValueKey('image_not_supported'),
                                      ));
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),

              // * SONG NAME AND ARTIS **********

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

              // * PLAY ICON *************

              BlocConsumer<PlayerCubit, PlayerState>(
                  listener: (context, state) {
                if (state is PlayerStatePlaying) {
                  widget.setIsRotating(true);
                  _playRotation();
                }
              }, builder: (context, state) {
                if (state is PlayerStatePlaying) {
                  return GestureDetector(
                    onTap: () {
                      context.read<PlayerCubit>().pauseSog();
                      _stopRotation();
                      widget.setIsRotating(false);
                    },
                    child: const Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 30,
                    ),
                  );
                } else if (state is PlayerStatePaused) {
                  return GestureDetector(
                    onTap: () {
                      context.read<PlayerCubit>().resumeSong();
                      _playRotation();
                      widget.setIsRotating(true);
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
