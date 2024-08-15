import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/domain/use_cases/song_use_cases.dart';
import 'package:palm_player/presentation/cubits/player/player_cubit.dart';
import 'package:palm_player/presentation/cubits/player/player_state.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_cubit.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_state.dart';
import 'package:palm_player/presentation/screens/album_screen.dart';
import 'package:palm_player/presentation/screens/home_screen.dart';
import 'package:palm_player/presentation/screens/settings_screen.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigator();
}

class _BottomNavigator extends State<BottomNavigator> {
  final List<Widget> _screens = const [
    HomeScreen(),
    AlbumScreen(),
    SettingsScreen()
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(26, 27, 32, 1),
      body: SafeArea(
          child: Stack(children: [
        IndexedStack(index: _selectedIndex, children: _screens),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 1,
                child: const ExpandiblePlayerController()))
      ])),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          child: BottomNavigationBar(
            backgroundColor: Colors.black,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.album), label: 'Album'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}

//* Expandible controller

class ExpandiblePlayerController extends StatefulWidget {
  const ExpandiblePlayerController({super.key});

  @override
  State<ExpandiblePlayerController> createState() =>
      _ExpandiblePlayerControllerState();
}

class _ExpandiblePlayerControllerState
    extends State<ExpandiblePlayerController> {
  late DraggableScrollableController _draggableController;
  bool _isdraggableOnMaxheight = false;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController();
  }

  @override
  void dispose() {
    _draggableController.dispose();
    super.dispose();
  }

  void setDraggableAutomaticPosition() {
    final double currentSize = _draggableController.size;

    if (currentSize >= 0.3) {
      _draggableController.animateTo(0.9,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack);

      setState(() {
        _isdraggableOnMaxheight = true;
      });
    } else {
      _draggableController.animateTo(0.08,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack);
      setState(() {
        _isdraggableOnMaxheight = false;
      });
    }

    setState(() {
      _isScrolling = false;
    });
  }

  void expandDraggableToMaxSize() {
    _draggableController.animateTo(0.9,
        duration: const Duration(milliseconds: 600), curve: Curves.easeOutBack);

    setState(() {
      _isdraggableOnMaxheight = true;
    });
  }

  void collapseDraggableToMinSize() {
    _draggableController.animateTo(0.08,
        duration: const Duration(milliseconds: 600), curve: Curves.easeOutBack);
    setState(() {
      _isdraggableOnMaxheight = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.08,
        minChildSize: 0.08,
        maxChildSize: 0.9,
        controller: _draggableController,
        builder: (BuildContext context, ScrollController scrollController) {
          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  _isScrolling == false) {
                setState(() {
                  _isScrolling = true;
                });
                setDraggableAutomaticPosition();
              }

              return true;
            },
            child: Container(
                decoration: BoxDecoration(
                    color: _isdraggableOnMaxheight
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Center(
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
                                expandDraggableToMaxSize();
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
                              child:
                                  BlocBuilder<GetSongArtcubit, GetSongArtState>(
                                bloc: GetSongArtcubit(
                                    context.read<SongUseCases>())
                                  ..getSongArt(context
                                      .read<PlayerCubit>()
                                      .state
                                      .currentSong
                                      ?.id),
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
                                    return const Icon(
                                        Icons.image_not_supported);
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
                                      context
                                              .watch<PlayerCubit>()
                                              .state
                                              .currentSong
                                              ?.name ??
                                          'Unknown',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
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
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.3)),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 1,
                                    )
                                  ]),
                            ),
                            const Spacer(),
                            BlocBuilder<PlayerCubit, PlayerState>(
                                builder: (context, state) {
                              if (state is PlayerStatePlaying) {
                                return GestureDetector(
                                  onTap: () {
                                    // playerCubit.pauseSog();
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
                                    // playerCubit.resumeSong();
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
                  ),
                )),
          );
        });
  }
}
