import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/presentation/cubits/player/player_cubit.dart';
import 'package:palm_player/presentation/cubits/player/player_state.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_cubit.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_state.dart';
import 'package:palm_player/presentation/utils/darken_color.dart';

class ExpandiblePlayerLargeContent extends StatefulWidget {
  final bool isRotating;
  final void Function(bool) setIsRotating;
  final void Function() collapseDraggableToMinSize;

  const ExpandiblePlayerLargeContent(
      {super.key,
      required this.isRotating,
      required this.setIsRotating,
      required this.collapseDraggableToMinSize});

  @override
  State<ExpandiblePlayerLargeContent> createState() =>
      _ExpandiblePlayerLargeContentState();
}

class _ExpandiblePlayerLargeContentState
    extends State<ExpandiblePlayerLargeContent>
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(children: [
      // * Geometric background  *****
      Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: Container(
            height: 250,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Theme.of(context).primaryColor,
                  darken(Theme.of(context).primaryColor, 0.2)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40))),
          )),

      // * Content  ****************
      SizedBox(
        height: screenHeight * 0.8,
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),

              // *  Down Arrow **

              GestureDetector(
                onTap: () {
                  widget.collapseDraggableToMinSize();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_drop_down_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Playing',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    )
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // * Rotating image **

              RotationTransition(
                turns: _animateRotateController,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5)),
                  child: CircleAvatar(
                    maxRadius: 140,
                    child: Stack(alignment: Alignment.center, children: [
                      ClipOval(
                        child: BlocBuilder<GetSongArtcubit, GetSongArtState>(
                            builder: (context, state) {
                          return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              switchInCurve: Curves.easeIn,
                              switchOutCurve: Curves.easeOut,
                              child: (state is GetSongArtStateLoaded &&
                                      state.albumArt != null)
                                  ? Image.memory(
                                      state.albumArt!,
                                      fit: BoxFit.fill,
                                      key: ValueKey(state.albumArt),
                                      scale: 0.1,
                                    )
                                  : (_imageCached != null)
                                      ? Image.memory(
                                          _imageCached!,
                                          fit: BoxFit.cover,
                                          key: ValueKey(_imageCached),
                                          scale: 0.1,
                                        )
                                      : const Icon(
                                          Icons.image_not_supported,
                                          key: ValueKey('image_not_supported'),
                                          size: 180,
                                        ));
                        }),
                      ),
                      Positioned(
                          child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[900]),
                        child: Center(
                          child: Container(
                            height: 20,
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(199, 199, 199, 1),
                                shape: BoxShape.circle),
                          ),
                        ),
                      ))
                    ]),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // * Song name and Artis name.

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      context.watch<PlayerCubit>().state.currentSong?.name ??
                          'Unknown',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      context.watch<PlayerCubit>().state.currentSong?.artist ??
                          'Unknown',
                      style: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.4),
                          fontSize: 18),
                    )
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Row(
                // * Previous song button

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(
                    width: 30,
                  ),

                  // * Play button

                  BlocBuilder<PlayerCubit, PlayerState>(
                    builder: (context, state) {
                      if (state is PlayerStatePlaying) {
                        return GestureDetector(
                          onTap: () {
                            context.read<PlayerCubit>().pauseSog();
                            _stopRotation();
                            widget.setIsRotating(false);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.stop_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        );
                      }

                      if (state is PlayerStatePaused) {
                        return GestureDetector(
                          onTap: () {
                            context.read<PlayerCubit>().resumeSong();
                            _playRotation();
                            widget.setIsRotating(true);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    width: 30,
                  ),

                  // * Next song button
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
