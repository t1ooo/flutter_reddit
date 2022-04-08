import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import 'subscriptions.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('SubscriptionsScreen'),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              child: TabBar(
                labelColor: Colors.blue,
                tabs: [
                  Tab(text: 'Subscriptions'),
                  Tab(text: 'Popular'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Subscriptions(),
                  Text('Custom Feed'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
