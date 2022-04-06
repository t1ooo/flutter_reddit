import 'package:flutter/material.dart';

import 'home/home.dart';
import 'home/home_screen.dart';

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _selectedIndex = 0;

  List<Widget> screens = [
    Home(),
    Home(),
    Home(),
    Home(),
    Home(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('User Profile'),
      // ),
      // body: screens[_selectedIndex],
      body: HomeScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '3',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '4',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '5',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
