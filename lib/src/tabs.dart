import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/subscriptions/subscriptions_screen.dart';
import 'package:flutter_reddit_prototype/src/user_menu.dart';

import 'home/home.dart';
import 'home/home_screen.dart';

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _selectedIndex = 0;

  List<Widget> _screens = [
    HomeScreen(),
    SubscriptionsScreen(),
    Home(),
    Home(),
    Home(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: UserMenu(user:null),
      drawer: UserMenu(),
      // TODO: add appbar, set title, remove Scaffold from tabs (HomeScreen, SubscriptionsScreen)
      // appBar: AppBar(
      //   title: Text('User Profile'),
      // ),
      // body: screens[_selectedIndex],
      body: _screens[_selectedIndex],
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

    /* return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '1',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '2',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '3',
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              return SafeArea(
                top: false,
                bottom: false,
                child: CupertinoApp(
                  home: CupertinoPageScaffold(
                    resizeToAvoidBottomInset: false,
                    child: _screens[_selectedIndex],
                  ),
                ),
              );
            },
          );
        }); */
  }
}
