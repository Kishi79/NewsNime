import 'package:flutter/material.dart';
import 'bookmark_screen.dart'; // Akan dibuat nanti
import 'home_screen.dart'; // Akan dibuat nanti
import 'profile_screen.dart'; // Akan dibuat nanti
import 'utils/helper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<Widget> body = const [
    HomeScreen(),
    BookmarkScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: cWhite,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 0 ? Icons.home : Icons.home_outlined),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 1 ? Icons.bookmark : Icons.bookmark_border_outlined),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 2 ? Icons.person : Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}