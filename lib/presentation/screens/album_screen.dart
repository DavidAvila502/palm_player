import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/presentation/cubits/album/get_albums/get_albums_cubit.dart';
import 'package:palm_player/presentation/cubits/album/get_albums/get_albums_state.dart';
import 'package:palm_player/presentation/widgets/album_screen/album_list.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreen();
}

class _AlbumScreen extends State<AlbumScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      BlocBuilder<GetAlbumsCubit, GetAlbumsState>(
          builder: (BuildContext context, state) {
        if (state is GetAlbumsStateLoaded) {
          return state.albums.isNotEmpty
              ? Expanded(
                  child: AlbumList(
                    albums: state.albums,
                  ),
                )
              : const Center(
                  child: Text(
                    'Nothing to show.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
        } else if (state is GetAlbumsStateLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return const Center(
            child: Text(
              'Nothing to show.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      }),
      SizedBox(height: screenHeight * 0.1)
    ]);
  }
}
