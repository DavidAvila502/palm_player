import 'package:flutter/material.dart';
import 'package:palm_player/presentation/screens/album_screen.dart';
import 'package:palm_player/presentation/screens/home_screen.dart';

class TopNavigator extends StatelessWidget {
  const TopNavigator({super.key});
  // final List<Widget> _screens = const [HomeScreen(), AlbumScreen()];
  final List<Widget> _screens = const [
    KeepAlivePage(child: HomeScreen()),
    KeepAlivePage(child: AlbumScreen()),
  ];

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

class KeepAlivePage extends StatefulWidget {
  final Widget child;

  const KeepAlivePage({super.key, required this.child});

  @override
  State<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
