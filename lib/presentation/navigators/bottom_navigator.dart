import 'package:flutter/material.dart';
import 'package:palm_player/presentation/screens/home_screen.dart';
import 'package:palm_player/presentation/screens/search_screen.dart';
import 'package:palm_player/presentation/screens/settings_screen.dart';
import 'package:palm_player/presentation/widgets/bottom_navigator/expandible_player_controller.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigator();
}

class _BottomNavigator extends State<BottomNavigator> {
  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    SettingsScreen()
  ];
  int _selectedIndex = 0;
  bool _isExpandibleSmall = true;

  void setIsExpandibleSmall(bool param) {
    setState(() {
      _isExpandibleSmall = param;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double bottomNavigationBarHeight = kBottomNavigationBarHeight;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(26, 27, 32, 1),
      body: SafeArea(
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
      ])),
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
                    child: BottomNavigationBar(
                      backgroundColor: Colors.black,
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                            icon: Icon(Icons.home), label: 'Home'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.search), label: 'Search'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.settings), label: 'Settings'),
                      ],
                      currentIndex: _selectedIndex,
                      selectedItemColor: Theme.of(context).primaryColor,
                      unselectedItemColor: Colors.grey,
                      onTap: (int index) {
                        setState(() {
                          _selectedIndex = index;
                        });
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
