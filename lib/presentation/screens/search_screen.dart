import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/domain/entities/song.dart';
import 'package:palm_player/presentation/cubits/song/get_all_songs/get_all_songs_cubit.dart';
import 'package:palm_player/presentation/cubits/song/get_all_songs/get_all_songs_state.dart';
import 'package:palm_player/presentation/widgets/home_screen/song_list.dart';

// TODO: SET A PLAYLIST BASED ON THE FITLER

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Song?> allSongs = [];
  List<Song?> filteredSongs = [];
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterSongs() {
    if (searchController.text == '') {
      return;
    }

    final List<Song?> newSongs = allSongs.where((song) {
      if (song == null) {
        return false;
      }

      if (song.name!
          .toLowerCase()
          .contains(searchController.text.toLowerCase())) {
        return true;
      }

      return false;
    }).toList();

    if (!(const DeepCollectionEquality().equals(filteredSongs, newSongs))) {
      setState(() {
        filteredSongs = newSongs;
      });
    }

    return;
  }

  void onChangeText(String value) {
    filterSongs();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return BlocListener<GetAllSongsCubit, GetAllSongsState>(
      listener: (context, state) {
        if (state is GetAllSongsStateLoaded) {
          setState(() {
            allSongs = state.songList;
          });
          filterSongs();
        }
      },
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                  padding: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.3),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: onChangeText,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: 'Enter a song name...',
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.4)),
                        border: InputBorder.none),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: screenHeight * 0.7,
                width: screenWidth * 0.9,
                child: SongList(
                  songs: filteredSongs,
                ))
          ],
        ),
      ),
    );
  }
}
