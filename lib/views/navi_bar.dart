/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5
import 'package:flutter/material.dart';
import 'package:sweatpals/views/home_view.dart';
import 'package:sweatpals/views/map_view.dart';
import 'package:sweatpals/views/chats_view.dart';
import 'package:sweatpals/views/profile_view.dart';
/// Navigation Menu 
class NaviBar extends StatefulWidget {
  const NaviBar({Key? key}) : super(key: key);

  @override
  NaviBarState createState() => NaviBarState();
}
/// Navigation Background Task
class NaviBarState extends State<NaviBar> {
  /// For Tracking Index of Screen
  int currentPageIndex = 0;
 /// List of Screen/Pages
  final screens = [
    const HomeView(),
    const MapView(),
    const ChatsView(),
    const ProfileView(),
  ];
  /// Process of Navigation
  @override
  Widget build(BuildContext context) => Scaffold(
      body: screens[currentPageIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.grey.shade800,
          indicatorColor: Colors.green.shade500,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        child: NavigationBar(
          height: 60,
          animationDuration: const Duration(seconds: 1),
          selectedIndex: currentPageIndex,
          onDestinationSelected: (currentPageIndex) {
            setState(() => this.currentPageIndex = currentPageIndex);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
              selectedIcon: Icon(Icons.home),
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              label: 'Map',
              selectedIcon: Icon(Icons.map),
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_outlined),
              label: 'Chat',
              selectedIcon: Icon(Icons.chat),
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outlined),
              label: 'Profile',
              selectedIcon: Icon(Icons.person),
            ),
          ],
        ),
      ));
}
