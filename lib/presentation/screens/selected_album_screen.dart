import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/domain/use_cases/album_use_cases.dart';
import 'package:palm_player/presentation/cubits/album/get_album_art/get_album_art_cubit.dart';
import 'package:palm_player/presentation/cubits/album/get_album_art/get_album_art_state.dart';
import 'package:palm_player/presentation/cubits/album/set_current_album/set_current_album_cubit.dart';
import 'package:palm_player/presentation/cubits/album/set_current_album/set_current_album_state.dart';

class SelectedAlbumScreen extends StatelessWidget {
  const SelectedAlbumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // * Hide button
        const Row(
          children: [
            SizedBox(
              height: 30,
            ),
            Icon(
              Icons.keyboard_arrow_down_outlined,
              color: Colors.white,
              size: 30,
            ),
            Text('Playing'),
          ],
        ),
        const SizedBox(
          height: 10,
        ),

        // * Content
        BlocBuilder<SetCurrentAlbumCubit, SetCurrentAlbumState>(
            builder: (BuildContext context, state) {
          if (state is SetCurrentAlbumStateLoaded) {
            return SingleChildScrollView(
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
                              color: Color.fromRGBO(255, 255, 255, 0.1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            children: [
                              Text(
                                state.album.name ?? 'Unknown',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                state.album.artist ?? 'Unknown',
                                style: const TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 0.5),
                                    fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        )),

                    // * Album Image
                    Positioned(
                      bottom: 100,
                      child: BlocBuilder<GetAlbumArtCubit, GetAlbumArtState>(
                          bloc: GetAlbumArtCubit(context.read<AlbumUseCases>())
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
                                    child:
                                        const Icon(Icons.image_not_supported),
                                  ));
                            }
                          }),
                    ),
                  ],
                ),

                // * Buttons
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'play',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'shuffle',
                      style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.5),
                          fontSize: 20),
                    ),
                  ],
                )
              ],
            ));
          } else {
            return const Center(
              child: Text('Nothing to show'),
            );
          }
        })
      ],
    );
  }
}
