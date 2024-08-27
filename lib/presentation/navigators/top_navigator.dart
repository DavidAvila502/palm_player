import 'package:flutter/material.dart';
import 'package:palm_player/presentation/screens/album_screen.dart';
import 'package:palm_player/presentation/screens/home_screen.dart';

class TopNavigator extends StatelessWidget {
  const TopNavigator({super.key});
  final List<Widget> _screens = const [HomeScreen(), AlbumScreen()];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _screens.length,
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(26, 27, 32, 1),
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(26, 27, 32, 1),
            title: const Text(
              'Library',
              style: TextStyle(color: Colors.white),
            ),
            bottom: const TabBar(tabs: <Widget>[
              Tab(child: Text('All songs')),
              Tab(
                child: Text('Albums'),
              )
            ], dividerColor: Color.fromRGBO(255, 255, 255, 0.1)),
          ),
          body: TabBarView(children: _screens),
        ));
  }
}
