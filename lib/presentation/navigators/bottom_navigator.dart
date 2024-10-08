import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/presentation/navigators/top_navigator.dart';
import 'package:palm_player/presentation/screens/search_screen.dart';
import 'package:palm_player/presentation/screens/selected_album_screen.dart';
import 'package:palm_player/presentation/screens/settings_screen.dart';
import 'package:palm_player/presentation/utils/handle_bottom_navigation_index.dart';
import 'package:palm_player/presentation/widgets/bottom_navigator/custom_bottom_navigation_bar.dart';
import 'package:palm_player/presentation/widgets/bottom_navigator/custom_bottom_navigation_bar_item.dart';
import 'package:palm_player/presentation/widgets/bottom_navigator/expandible_player_controller.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigator();
}

class _BottomNavigator extends State<BottomNavigator> {
  final List<Widget> _screens = const [
    TopNavigator(),
    SearchScreen(),
    SettingsScreen(),
    SelectedAlbumScreen()
  ];
  int _selectedIndex = 0;
  bool _isExpandibleSmall = true;
  bool showHiddenScreen = false;

  void setIsExpandibleSmall(bool param) {
    setState(() {
      _isExpandibleSmall = param;
    });
  }

  void setSelectedScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double bottomNavigationBarHeight = kBottomNavigationBarHeight;
    // final visibleScreens = showHiddenScreen ? _screens : _screens.sublist(0, 3);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(26, 27, 32, 1),
      body: SafeArea(
          child: RepositoryProvider<HandleBottomNavigationIndex>(
        create: (context) =>
            HandleBottomNavigationIndex(setSelectedScreen: setSelectedScreen),
        child: Stack(children: [
          IndexedStack(index: _selectedIndex, children: _screens),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                  height: screenHeight * 1,
                  child: ExpandiblePlayerController(
                    notifyToBottomNavigatorExpandibleIsSmall:
                        setIsExpandibleSmall,
                  )))
        ]),
      )),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _isExpandibleSmall
              ? Theme.of(context).primaryColor
              : const Color.fromRGBO(26, 27, 32, 1),
        ),
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            child: _isExpandibleSmall
                ? ClipRRect(
                    key: const ValueKey('BottomNavigationBar'),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    child: CustomBottomNavigationBar(
                      selectedItemColor: Theme.of(context).primaryColor,
                      selectedIndex: _selectedIndex,
                      backgroundColor: Colors.black,
                      items: const <CustomBottomNavigationBarItem>[
                        CustomBottomNavigationBarItem(
                            icon: Icons.home, label: 'Home'),
                        CustomBottomNavigationBarItem(
                            icon: Icons.search, label: 'Search'),
                        CustomBottomNavigationBarItem(
                            icon: Icons.settings, label: 'Settings')
                      ],
                      onTap: (int index) {
                        setSelectedScreen(index);
                      },
                    ),
                  )
                : Container(
                    key: const ValueKey('HideContainer'),
                    height: bottomNavigationBarHeight)),
      ),
    );
  }
}
