import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/presentation/cubits/song/get_all_songs/get_all_songs_cubit.dart';
import 'package:palm_player/presentation/cubits/song/get_all_songs/get_all_songs_state.dart';
import 'package:palm_player/presentation/widgets/shared/song_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder<GetAllSongsCubit, GetAllSongsState>(
              builder: (context, state) {
                if (state is GetAllSongsStateLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is GetAllSongsStateLoaded) {
                  if (state.songList.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nothing to show.',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  // * SONG LIST
                  return SongList(
                    songs: state.songList,
                  );
                } else {
                  return const Center(
                    child: Text(
                      'Nothing to show.',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.1,
        )
      ],
    );
  }
}
