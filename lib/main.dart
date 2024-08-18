import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/data/datasources/local/album/album_local_datasource_imp.dart';
import 'package:palm_player/data/datasources/local/song/song_local_datasource2_imp.dart';
import 'package:palm_player/data/repositories/album_repository_imp.dart';
import 'package:palm_player/data/repositories/song_repository_imp.dart';
import 'package:palm_player/domain/use_cases/album_use_cases.dart';
import 'package:palm_player/domain/use_cases/song_use_cases.dart';
import 'package:palm_player/presentation/cubits/player/player_cubit.dart';
import 'package:palm_player/presentation/cubits/song/get_all_songs/get_all_songs_cubit.dart';
import 'package:palm_player/presentation/cubits/song/get_song_art/get_song_art_cubit.dart';
import 'package:palm_player/presentation/navigators/bottom_navigator.dart';

void main() {
  runApp(MultiRepositoryProvider(providers: [
    RepositoryProvider<SongUseCases>(
        create: (context) => SongUseCases(
            SongRepositoryImp(songLocalDatasource: SongLocalDatasource2Imp()))),
    RepositoryProvider<AlbumUseCases>(
        create: (context) => AlbumUseCases(AlbumRepositoryImp(
            albumLocalDatasource: AlbumLocalDatasourceImp())))
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => PlayerCubit()),
          BlocProvider(
              create: (BuildContext context) =>
                  GetAllSongsCubit(context.read<SongUseCases>())
                    ..getAllSongs()),
          BlocProvider(
              create: (BuildContext context) =>
                  GetSongArtcubit(context.read<SongUseCases>()))
        ],
        child: const BottomNavigator(),
      ),
    );
  }
}
