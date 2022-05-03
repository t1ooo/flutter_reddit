import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../search/search_field.dart';
import '../user_menu.dart';
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

// class HomeScreenV2 extends StatelessWidget {
//   const HomeScreenV2({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('HomeScreen'),
//         ),
//         body: CustomScrollView(
//           slivers: [
//             SliverAppBar(),
//             // SizedBox(height: topPadding),
//             // Padding(
//             //   padding: pagePadding,
//             //   child: SearchField(),
//             // ),

//             SliverList(
//               delegate: SliverChildListDelegate(
//                 [
//                   Padding(
//                     padding: pagePadding,
//                     child: SearchField(),
//                   ),
//                   Container(
//                     child: TabBar(
//                       labelColor: Colors.blue,
//                       tabs: [
//                         Tab(child: Text('Home')),
//                         Tab(child: Text('Popular')),
//                       ],
//                     ),
//                   ),
//                   // Expanded(
//                   //   child: TabBarView(
//                   //     children: [
//                   //       Home(),
//                   //       Popular(),
//                   //     ],
//                   //   ),
//                   // ),
//                   // TabBarView(
//                   //   children: [
//                   //     Home(),
//                   //     Popular(),
//                   //   ],
//                   // ),
//                 ],
//               ),
//             ),

//             SliverFillRemaining(
//               child: TabBarView(
//                 children: <Widget>[
//                   Home(),
//                   Popular(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HomeScreenV3 extends StatelessWidget {
//   const HomeScreenV3({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('HomeScreen'),
//         ),
//         body: NestedScrollView(
//           headerSliverBuilder: (context, value) {
//             return [
//               Container(
//                 child: TabBar(
//                   labelColor: Colors.blue,
//                   tabs: [
//                     Tab(child: Text('Home')),
//                     Tab(child: Text('Popular')),
//                   ],
//                 ),
//               )
//             ];
//           },
//           body: Expanded(
//             child: TabBarView(
//               children: [
//                 Home(),
//                 Popular(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class HomeScreenV4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          // toolbarHeight: 85,
          // toolbarHeight: 150,
          // elevation: 0,
          iconTheme: appBarIconThemeDark,
          flexibleSpace: SearchField(),
        ),
        drawer: UserMenu(),
        body: DefaultTabController(
          length: 2, // This is the number of tabs.
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // SliverAppBar(
                //   collapsedHeight: 80,
                //   flexibleSpace: Padding(
                //     padding: EdgeInsets.only(
                //         top: 10, left: 10, right: 10, bottom: 10),
                //     child: SearchField(),
                //   ),
                //   pinned: true,
                // ),

                SliverAppBar(
                  automaticallyImplyLeading: false,
                  flexibleSpace: Container(
                    width: 100,
                    child: TabBar(
                      // padding: EdgeInsets.zero,
                      // labelPadding: EdgeInsets.zero,
                      // labelPadding: EdgeInsets.only(left: 300),
                      indicatorColor: selectedColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      // indicator: BoxDecoration(
                      //   border: Border(
                      //     bottom: BorderSide(
                      //       color: Colors.blue,
                      //       width: 2.0,
                      //     ),
                      //   ),
                      // ),
                      tabs: [
                        Tab(text: 'Home'),
                        Tab(text: 'Popular'),
                        // Container( width: 100, child: Tab(text: 'Home')),
                        // Container( width: 100, child: Tab(text: 'Popular')),

                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: Container(
                        //     width: 150,
                        //     // decoration: BoxDecoration(
                        //     //   border: Border(
                        //     //     bottom: BorderSide(
                        //     //       color: Colors.blue,
                        //     //       width: 2.0,
                        //     //     ),
                        //     //   ),
                        //     // ),
                        //     child: Tab(text: 'Home'),
                        //   ),
                        // ),
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Container(
                        //     width: 150,
                        //     // decoration: BoxDecoration(
                        //     //   border: Border(
                        //     //     bottom: BorderSide(
                        //     //       color: Colors.blue,
                        //     //       width: 2.0,
                        //     //     ),
                        //     //   ),
                        //     // ),
                        //     child: Tab(text: 'Popular'),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),

                // SliverAppBar(
                //   floating: true,
                //   pinned: false,
                //   snap: false,
                //   centerTitle: false,
                //   title: Text('Kindacode.com'),
                //   actions: [
                //     IconButton(
                //       icon: Icon(Icons.shopping_cart),
                //       onPressed: () {},
                //     ),
                //   ],
                //   bottom: AppBar(
                //     title: Container(
                //       width: double.infinity,
                //       // height: 40,
                //       color: Colors.white,
                //       child: Center(
                //         child: TextField(
                //           decoration: InputDecoration(
                //               hintText: 'Search for something',
                //               prefixIcon: Icon(Icons.search),
                //               suffixIcon: Icon(Icons.camera_alt)),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // // SliverAppBar(
                // //   title: const Text('HomeScreen'),
                // //   floating: true,
                // //   pinned: false,
                // //   snap: false,
                // //   primary: true,
                // //   forceElevated: innerBoxIsScrolled,
                // //   bottom: AppBar(
                // //     title: SearchField(),
                // //   ),
                // // ),
                // // SearchField(),
                // // SliverSafeArea(
                // //     top: false,
                // //     sliver: SliverAppBar(
                // //       title: const Text('HomeScreen'),
                // //       floating: true,
                // //       pinned: false,
                // //       snap: false,
                // //       primary: true,
                // //       forceElevated: innerBoxIsScrolled,
                // //       bottom: AppBar(title: SearchField(),),
                // //     ),
                // //   ),
                // // SliverOverlapAbsorber(
                // //   handle:
                // //       NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                // //   sliver: SliverSafeArea(
                // //     top: false,
                // //     sliver: SliverAppBar(
                // //       // title: const Text('HomeScreen'),
                // //       floating: true,
                // //       pinned: false,
                // //       snap: false,
                // //       primary: true,
                // //       forceElevated: innerBoxIsScrolled,
                // //       bottom: TabBar(
                // //         // These are the widgets to put in each tab in the tab bar.
                // //         tabs: _tabs
                // //             .map((String name) => Tab(text: name))
                // //             .toList(),
                // //       ),
                // //     ),
                // //   ),
                // // ),
                // SliverAppBar(
                //   // title: const Text('HomeScreen'),
                //   floating: true,
                //   pinned: false,
                //   snap: false,
                //   primary: true,
                //   forceElevated: innerBoxIsScrolled,
                //   bottom: TabBar(
                //     // These are the widgets to put in each tab in the tab bar.
                //     tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                //   ),
                // ),
              ];
            },
            body: TabBarView(
              children: [
                Home(),
                Popular(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
