import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import 'home.dart';
import 'popular.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Popular'),
            ],
          ),
          // title: Text('Hacker News'),
        ),
        body: TabBarView(
          children: [
            // Padding(
            //   padding: pagePadding,
            //   child: Home(),
            // ),
            // Padding(
            //   padding: pagePadding,
            //   child: Popular(),
            // ),
            Home(),
            Popular(),
          ],
        ),
      ),
    );
  }
}
