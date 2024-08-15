import 'package:flutter/material.dart';
import 'package:palm_player/data/datasources/local/album/album_local_datasource_imp.dart';
import 'package:palm_player/data/repositories/album_repository_imp.dart';
import 'package:palm_player/domain/entities/album.dart';
import 'package:palm_player/domain/use_cases/album_use_cases.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreen();
}

class _AlbumScreen extends State<AlbumScreen> {
  final AlbumUseCases _albumUsecases = AlbumUseCases(
      AlbumRepositoryImp(albumLocalDatasource: AlbumLocalDatasourceImp()));

  List<Album> albumList = [];

  Future<void> getAlbums() async {
    List<Album> albums = await _albumUsecases.getAlbums();

    setState(() {
      albumList = albums;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),

        ElevatedButton(onPressed: getAlbums, child: const Text('Fetch albums')),

        const SizedBox(
          height: 20,
        ),

        // List of albums

        SizedBox(
          height: 500,
          child: ListView.separated(
              itemCount: albumList.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    FutureBuilder(
                        future: _albumUsecases.getAlbumArt(albumList[index].id),
                        builder: (BuildContext context, snapShot) {
                          return SizedBox(
                            height: 80,
                            width: 80,
                            child: snapShot.hasData
                                ? Image.memory(snapShot.data!)
                                : const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  ),
                          );
                        }),
                    Container(
                      color: Colors.black,
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        albumList[index].name!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                );
              }),
        )
      ],
    );
  }
}
