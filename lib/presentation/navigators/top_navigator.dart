import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/presentation/cubits/navigator/navigator_cubit.dart';
import 'package:palm_player/presentation/cubits/navigator/navigator_cubit_state.dart';
import 'package:palm_player/presentation/screens/album_screen.dart';
import 'package:palm_player/presentation/screens/home_screen.dart';

class TopNavigator extends StatefulWidget {
  const TopNavigator({super.key});

  @override
  State<TopNavigator> createState() => _TopNavigatorState();
}

class _TopNavigatorState extends State<TopNavigator>
    with SingleTickerProviderStateMixin {
  late TabController? _tabController;

  final List<Widget> _screens = const [
    KeepAlivePage(child: HomeScreen()),
    KeepAlivePage(child: AlbumScreen()),
  ];

  final List<Tab> _tabs = const [
    Tab(child: Text('All songs')),
    Tab(
      child: Text('Albums'),
    )
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: _screens.length,
      vsync: this,
    );

    _tabController?.addListener(() {
      if (!_tabController!.indexIsChanging) {
        context
            .read<NavigatorCubit>()
            .updateTopNavigatorIndex(_tabController!.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void changeTap(int index) {
    _tabController?.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigatorCubit, NavigatorCubitState>(
      listener: (context, state) {
        if (state.topNavigatorIndex == _tabController!.index) {
          return;
        }
        changeTap(state.topNavigatorIndex);
      },
      child: DefaultTabController(
          length: _screens.length,
          child: Scaffold(
            backgroundColor: const Color.fromRGBO(26, 27, 32, 1),
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(26, 27, 32, 1),
              title: const Text(
                'Library',
                style: TextStyle(color: Colors.white),
              ),
              bottom: TabBar(
                  controller: _tabController,
                  tabs: _tabs,
                  dividerColor: const Color.fromRGBO(255, 255, 255, 0.1)),
            ),
            body: TabBarView(
              controller: _tabController,
              children: _screens,
            ),
          )),
    );
  }
}

class BottomNavigatorCubitState {}

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
