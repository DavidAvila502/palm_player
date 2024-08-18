import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/presentation/cubits/player/player_cubit.dart';
import 'package:palm_player/presentation/cubits/player/player_state.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_cubit.dart';
import 'package:palm_player/presentation/widgets/bottom_navigator/expandible_player_large_content.dart';
import 'package:palm_player/presentation/widgets/bottom_navigator/expandible_player_samall_content.dart';

class ExpandiblePlayerController extends StatefulWidget {
  const ExpandiblePlayerController({super.key});

  @override
  State<ExpandiblePlayerController> createState() =>
      _ExpandiblePlayerControllerState();
}

class _ExpandiblePlayerControllerState
    extends State<ExpandiblePlayerController> {
  late DraggableScrollableController _draggableController;
  bool _isScrolling = false;
  bool _isSmall = true;
  bool _isRotating = false;

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController();

    _draggableController.addListener(() {
      final double currentSize = _draggableController.size;

      if (currentSize >= 0.3) {
        setState(() {
          _isSmall = false;
        });

        return;
      }

      setState(() {
        _isSmall = true;
      });

      return;
    });
  }

  @override
  void dispose() {
    _draggableController.dispose();
    super.dispose();
  }

  void setIsRotating(bool param) {
    setState(() {
      _isRotating = param;
    });
  }

  Future<void> setDraggableAutomaticPosition() async {
    if (_isScrolling) return;

    setState(() {
      _isScrolling = true;
    });

    final double currentSize = _draggableController.size;

    if (currentSize >= 0.3) {
      await _draggableController.animateTo(0.9,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack);
    } else {
      await _draggableController.animateTo(0.08,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack);
    }

    setState(() {
      _isScrolling = false;
    });
  }

  void expandDraggableToMaxSize() {
    _draggableController.animateTo(0.9,
        duration: const Duration(milliseconds: 900), curve: Curves.easeOutBack);
  }

  void collapseDraggableToMinSize() {
    _draggableController.animateTo(0.08,
        duration: const Duration(milliseconds: 900), curve: Curves.easeOutBack);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayerCubit, PlayerState>(
      listener: (context, state) {
        if (state is PlayerStatePlaying) {
          // Update Global Song Image
          context
              .read<GetSongArtcubit>()
              .getSongArt(context.read<PlayerCubit>().state.currentSong?.id);
          setIsRotating(true);
        }
      },
      child: DraggableScrollableSheet(
          initialChildSize: 0.08,
          minChildSize: 0.08,
          maxChildSize: 0.9,
          controller: _draggableController,
          builder: (BuildContext context, ScrollController scrollController) {
            return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification && !_isScrolling) {
                    setDraggableAutomaticPosition();
                  }

                  return true;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                      color: !_isSmall
                          ? Colors.grey[900]
                          : Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: SingleChildScrollView(
                    controller: scrollController,

                    // Dynamic content with transition
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      switchInCurve: Curves.easeInExpo,
                      switchOutCurve: Curves.easeOutExpo,
                      child: _isSmall
                          ? ExpandiblePlayerSamallContent(
                              key: const ValueKey(1),
                              isRotating: _isRotating,
                              setIsRotating: setIsRotating,
                              expandDraggableToMaxSize:
                                  expandDraggableToMaxSize,
                            )
                          : ExpandiblePlayerLargeContent(
                              key: const ValueKey(2),
                              isRotating: _isRotating,
                              setIsRotating: setIsRotating,
                              collapseDraggableToMinSize:
                                  collapseDraggableToMinSize,
                            ),
                    ),
                  ),
                ));
          }),
    );
  }
}
