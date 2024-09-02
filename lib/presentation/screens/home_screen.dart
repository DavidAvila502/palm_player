import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/presentation/cubits/song/get_all_songs/get_all_songs_cubit.dart';
import 'package:palm_player/presentation/cubits/song/get_all_songs/get_all_songs_state.dart';
import 'package:palm_player/presentation/widgets/home_screen/song_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: screenHeight * 0.7,
            width: screenWidth * 0.9,
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
        ],
      ),
    );
  }
}
