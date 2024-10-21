import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/domain/use_cases/album_use_cases.dart';
import 'package:palm_player/presentation/cubits/album/get_album_art/get_album_art_cubit.dart';
import 'package:palm_player/presentation/cubits/album/get_album_art/get_album_art_state.dart';
import 'package:palm_player/presentation/cubits/album/get_album_songs/get_album_songs_cubit.dart';
import 'package:palm_player/presentation/cubits/album/get_album_songs/get_album_songs_state.dart';
import 'package:palm_player/presentation/cubits/album/set_current_album/set_current_album_cubit.dart';
import 'package:palm_player/presentation/cubits/album/set_current_album/set_current_album_state.dart';
import 'package:palm_player/presentation/cubits/navigator/navigator_cubit.dart';
import 'package:palm_player/presentation/widgets/selected_album_sreen/album_buttons.dart';
import 'package:palm_player/presentation/widgets/selected_album_sreen/full_size_song_list.dart';

class SelectedAlbumScreen extends StatefulWidget {
  const SelectedAlbumScreen({super.key});

  @override
  State<SelectedAlbumScreen> createState() => _SelectedAlbumScreenState();
}

class _SelectedAlbumScreenState extends State<SelectedAlbumScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetAlbumSongsCubit(context.read<AlbumUseCases>()),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          // * Hide button
          Row(
            children: [
              const SizedBox(
                width: 30,
              ),
              GestureDetector(
                onTap: () {
                  context.read<NavigatorCubit>().updateBottomNavigatorIndex(0);
                },
                child: const Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),

          // * Content
          BlocConsumer<SetCurrentAlbumCubit, SetCurrentAlbumState>(
              listener: (context, state) {
            if (state is SetCurrentAlbumStateLoaded) {
              context.read<GetAlbumSongsCubit>().getAlbumSongs(state.album.id);
            }
          }, builder: (BuildContext context, state) {
            if (state is SetCurrentAlbumStateLoaded) {
              return Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // * Album Widget ******
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 240,
                          // decoration:
                          //     BoxDecoration(color: Colors.amber.withOpacity(0.1)),
                        ),

                        // * Name and Artist
                        Positioned(
                            bottom: 0,
                            left: 20,
                            right: 20,
                            child: Container(
                              height: 180,
                              padding: const EdgeInsets.only(
                                  top: 90, left: 10, right: 10),
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 0.07),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Column(
                                children: [
                                  Text(
                                    state.album.name ?? 'Unknown',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    state.album.artist ?? 'Unknown',
                                    style: const TextStyle(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.5),
                                        fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            )),

                        // * Album Image
                        Positioned(
                          bottom: 100,
                          child: BlocBuilder<GetAlbumArtCubit,
                                  GetAlbumArtState>(
                              bloc: GetAlbumArtCubit(
                                  context.read<AlbumUseCases>())
                                ..getAlbumArt(state.album.id),
                              builder: (context, state) {
                                if (state is GetAlbumArtStateLoaded) {
                                  return Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      height: 130,
                                      width: 130,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: state.albumArt != null
                                            ? Image.memory(
                                                state.albumArt!,
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(
                                                Icons.image_not_supported,
                                                size: 100,
                                              ),
                                      ));
                                } else {
                                  return Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      height: 130,
                                      width: 130,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: const Icon(
                                            Icons.image_not_supported),
                                      ));
                                }
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    // * Buttons *********
                    BlocBuilder<GetAlbumSongsCubit, GetAlbumSongsState>(
                        builder: (context, state) {
                      if (state is GetAlbumSongsStateLoaded) {
                        return AlbumButtons(albumSongs: state.songs);
                      } else {
                        return const AlbumButtons(albumSongs: []);
                      }
                    }),

                    const SizedBox(
                      height: 20,
                    ),

                    // * SONGS *****
                    BlocBuilder<GetAlbumSongsCubit, GetAlbumSongsState>(
                      builder: (BuildContext context, state) {
                        if (state is GetAlbumSongsStateLoaded) {
                          return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: state.songs.isNotEmpty
                                  ? FullSizeSongList(songList: state.songs)
                                  : const Center(
                                      child: Text(
                                        'Nothing to show.',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ));
                        }

                        if (state is GetAlbumSongsStateLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return const Text(
                            'Nothing to show.',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          );
                        }
                      },
                    )
                  ],
                )),
              );
            } else {
              return const Center(
                child: Text(
                  'Nothing to show',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            }
          }),

          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.1,
          )
        ],
      ),
    );
  }
}
