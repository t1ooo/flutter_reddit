import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import '../search/search_field.dart';
import '../widget/sized_placeholder.dart';
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
          title: Text('HomeScreen'),
        ),
        body: Column(
          children: [
            SizedBox(height: topPadding),
            Padding(
              // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              padding: pagePadding,
              child: SearchField(),
            ),
            Container(
              child: TabBar(
                labelColor: Colors.blue,
                tabs: [
                  Tab(child: Text('Home')),
                  Tab(child: Text('Popular')),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Home(),
                  Popular(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return DefaultTabController(
  //     length: 2,
  //     child: Scaffold(
  //       appBar: AppBar(
  //         // backgroundColor: Colors.white,
  //         flexibleSpace: Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //           child: TextField(
  //             decoration: InputDecoration(
  //               hintText: 'Search',
  //               border: OutlineInputBorder(),
  //             ),
  //           ),
  //         ),

  //         bottom: TabBar(
  //           tabs: [
  //             Tab(text: 'Home'),
  //             Tab(text: 'Popular'),
  //           ],
  //         ),
  //         // title: Text('Hacker News'),
  //       ),
  //       body: TabBarView(
  //         children: [
  //           // Padding(
  //           //   padding: pagePadding,
  //           //   child: Home(),
  //           // ),
  //           // Padding(
  //           //   padding: pagePadding,
  //           //   child: Popular(),
  //           // ),
  //           Home(),
  //           Popular(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: CustomScrollView(
  //       slivers: [
  //         SliverAppBar(
  //           floating: true,
  //           pinned: true,
  //           snap: false,
  //           centerTitle: false,
  //           flexibleSpace: Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
  //             child: TextField(
  //               decoration: InputDecoration(
  //                 hintText: 'Add a comment',
  //                 border: OutlineInputBorder(),
  //               ),
  //             ),
  //           ),
  //         ),
  //         // Other Sliver Widgets
  //         SliverList(
  //           delegate: SliverChildListDelegate([
  //             Container(
  //               height: 400,
  //               child: Center(
  //                 child: Text(
  //                   'This is an awesome shopping platform',
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               height: 1000,
  //               color: Colors.pink,
  //             ),
  //           ]),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
