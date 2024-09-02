import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/presentation/cubits/player/player_cubit.dart';
import 'package:palm_player/presentation/cubits/player/player_state.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_cubit.dart';
import 'package:palm_player/presentation/widgets/bottom_navigator/expandible_player_large_content.dart';
import 'package:palm_player/presentation/widgets/bottom_navigator/expandible_player_samall_content.dart';

// TODO: Experimental widget some scroll bugs must be fixed

class ExpandiblePlayerController extends StatefulWidget {
  final void Function(bool) notifyToBottomNavigatorExpandibleIsSmall;
  const ExpandiblePlayerController(
      {super.key, required this.notifyToBottomNavigatorExpandibleIsSmall});

  @override
  State<ExpandiblePlayerController> createState() =>
      _ExpandiblePlayerControllerState();
}

class _ExpandiblePlayerControllerState
    extends State<ExpandiblePlayerController> {
  late DraggableScrollableController _draggableController;
  bool _isDraggableBlocked = false;
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

        widget.notifyToBottomNavigatorExpandibleIsSmall(false);

        return;
      }

      setState(() {
        _isSmall = true;
      });

      widget.notifyToBottomNavigatorExpandibleIsSmall(true);

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

  Future<void> _setDraggableAutomaticPosition() async {
    if (_isDraggableBlocked) return;

    setState(() {
      _isDraggableBlocked = true;
    });

    final double currentSize = _draggableController.size;

    if (currentSize >= 0.3) {
      await _draggableController.animateTo(0.9,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack);
    } else {
      await _draggableController.animateTo(0.08,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack);
    }

    setState(() {
      _isDraggableBlocked = false;
    });
  }

  void expandDraggableToMaxSize() {
    if (_isDraggableBlocked) return;
    setState(() {
      _isDraggableBlocked = true;
    });
    _draggableController.animateTo(0.9,
        duration: const Duration(milliseconds: 400), curve: Curves.easeOutBack);

    setState(() {
      _isDraggableBlocked = false;
    });
  }

  void collapseDraggableToMinSize() {
    if (_isDraggableBlocked) return;

    setState(() {
      _isDraggableBlocked = true;
    });

    _draggableController.animateTo(0.08,
        duration: const Duration(milliseconds: 400), curve: Curves.easeOutBack);

    setState(() {
      _isDraggableBlocked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayerCubit, PlayerState>(
      listener: (context, state) {
        if (state.status == PlayerStatus.playing) {
          // Update Global Song Image
          context
              .read<GetSongArtcubit>()
              .getSongArt(context.read<PlayerCubit>().state.currentSong?.id);
          setIsRotating(true);
        } else if (state.status == PlayerStatus.stopped) {
          setIsRotating(false);
        } else if (state.status == PlayerStatus.paused) {
          setIsRotating(false);
        }
      },
      child: Stack(
        children: [
          DraggableScrollableSheet(
              initialChildSize: 0.08,
              minChildSize: 0.08,
              maxChildSize: 0.9,
              controller: _draggableController,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification &&
                          !_isDraggableBlocked) {
                        Future.delayed(const Duration(milliseconds: 150), () {
                          if (!_isDraggableBlocked) {
                            _setDraggableAutomaticPosition();
                          }
                        });
                      }

                      return true;
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                          color: !_isSmall
                              ? const Color.fromRGBO(26, 27, 32, 1)
                              : Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: SingleChildScrollView(
                        controller: scrollController,

                        // Dynamic content with transition
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 100),
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          child: _isSmall
                              ? ExpandiblePlayerSamallContent(
                                  key: const ValueKey(1),
                                  isRotating: _isRotating,
                                  expandDraggableToMaxSize:
                                      expandDraggableToMaxSize,
                                )
                              : ExpandiblePlayerLargeContent(
                                  key: const ValueKey(2),
                                  isRotating: _isRotating,
                                  collapseDraggableToMinSize:
                                      collapseDraggableToMinSize,
                                ),
                        ),
                      ),
                    ));
              }),
          if (_isDraggableBlocked)
            Positioned.fill(
                child: GestureDetector(
              onVerticalDragUpdate: (_) {},
              onTap: () {},
              child: Container(
                color: Colors.transparent,
              ),
            ))
        ],
      ),
    );
  }
}
