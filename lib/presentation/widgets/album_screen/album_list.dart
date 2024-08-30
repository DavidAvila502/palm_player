import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/domain/entities/album.dart';
import 'package:palm_player/domain/use_cases/album_use_cases.dart';
import 'package:palm_player/presentation/cubits/album/get_album_art/get_album_art_cubit.dart';
import 'package:palm_player/presentation/cubits/album/get_album_art/get_album_art_state.dart';
import 'package:palm_player/presentation/utils/handle_bottom_navigation_index.dart';

class AlbumList extends StatelessWidget {
  final List<Album> albums;
  const AlbumList({super.key, required this.albums});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: albums.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 10, mainAxisSpacing: 10, crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          // * Container and styles
          return GestureDetector(
            onTap: () {
              context.read<HandleBottomNavigationIndex>().setSelectedScreen(3);
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(34, 36, 48, 1),
                ),
                child: Stack(
                  children: [
                    // * ALBUM IMAGE
                    SizedBox.expand(
                        child: BlocBuilder<GetAlbumArtCubit, GetAlbumArtState>(
                            bloc:
                                GetAlbumArtCubit(context.read<AlbumUseCases>())
                                  ..getAlbumArt(albums[index].id),
                            builder: (BuildContext context, state) {
                              if (state is GetAlbumArtStateLoaded) {
                                return state.albumArt != null
                                    ? Image.memory(
                                        state.albumArt!,
                                        fit: BoxFit.cover,
                                      )
                                    : const Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 60,
                                        ),
                                      );
                              }

                              if (state is GetAlbumArtStateLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              return const Icon(
                                Icons.image_not_supported,
                                size: 60,
                              );
                            })),
                    // * ALBUM TITLE
                    Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0.7)),
                          child: Text(
                            albums[index].name ?? 'Unknown',
                            style: const TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
