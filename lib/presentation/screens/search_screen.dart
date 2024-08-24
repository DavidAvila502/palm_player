import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/domain/entities/song.dart';
import 'package:palm_player/presentation/cubits/song/get_all_songs/get_all_songs_cubit.dart';
import 'package:palm_player/presentation/cubits/song/get_all_songs/get_all_songs_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Song?> allSongs = [];
  List<Song?> filteredSongs = [];
  String filterParam = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void filterSongs() {
    if (filterParam == '') {
      return;
    }

    setState(() {
      filteredSongs = allSongs.where((song) {
        if (song == null) {
          return false;
        }

        if (song.name!.toLowerCase().contains(filterParam.toLowerCase())) {
          return true;
        }

        return false;
      }).toList();
    });
  }

  void onChangeFilter(String value) {
    setState(() {
      filterParam = value;
    });

    filterSongs();
  }

  @override
  Widget build(BuildContext context) {
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
              height: 35,
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
                    // controller: searchFieldController,
                    onChanged: onChangeFilter,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: 'Enter a song name...',
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.4)),
                        border: InputBorder.none),
                  )),
            ),
            SizedBox(
              height: 400,
              width: 300,
              child: ListView.builder(
                  itemCount: filteredSongs.length,
                  itemBuilder: (context, index) {
                    return Text(
                      filteredSongs[index]?.name ?? 'Unknown',
                      style: const TextStyle(color: Colors.white),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
