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

    return Scaffold(
      backgroundColor: const Color.fromRGBO(26, 27, 32, 1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // * Main colum
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: screenHeight * 0.7,
                    child: BlocBuilder<GetAllSongsCubit, GetAllSongsState>(
                      builder: (context, state) {
                        if (state is GetAllSongsStateLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is GetAllSongsStateLoaded) {
                          // * SONG LIST
                          return SongList(
                            state: state,
                          );
                        } else {
                          return const Text(
                            'Nothing to show.',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
