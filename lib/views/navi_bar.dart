import 'package:flutter/material.dart';

import 'package:sweatpals/views/home_view.dart';
import 'package:sweatpals/views/map_view.dart';
import 'package:sweatpals/views/chats_view.dart';
import 'package:sweatpals/views/profile_view.dart';

class NaviBar extends StatefulWidget {
  const NaviBar({Key? key}) : super(key: key);

  @override
  _NaviBarState createState() => _NaviBarState();
}

class _NaviBarState extends State<NaviBar> {
  int currentPageIndex = 0;

  final screens = [
    const HomeView(),
    const MapView(),
    const ChatsView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
      body: screens[currentPageIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.grey.shade800,
          indicatorColor: Colors.green.shade500,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        child: NavigationBar(
          height: 60,
          animationDuration: Duration(seconds: 1),
          selectedIndex: currentPageIndex,
          onDestinationSelected: (currentPageIndex) {
            setState(() => this.currentPageIndex = currentPageIndex);
          },
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
              selectedIcon: Icon(Icons.home),
            ),
            const NavigationDestination(
              icon: Icon(Icons.map_outlined),
              label: 'Map',
              selectedIcon: Icon(Icons.map),
            ),
            const NavigationDestination(
              icon: Icon(Icons.chat_outlined),
              label: 'Chat',
              selectedIcon: Icon(Icons.chat),
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outlined),
              label: 'Profile',
              selectedIcon: Icon(Icons.person),
            ),
          ],
        ),
      ));
}
