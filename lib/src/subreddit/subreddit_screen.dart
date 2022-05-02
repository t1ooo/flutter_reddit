import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:flutter_reddit_prototype/src/provider.dart';
import 'package:flutter_reddit_prototype/src/widget/custom_future_builder.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/subreddit.dart';
import '../search/search_field.dart';
import '../style/style.dart';
import '../util/snackbar.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/loader.dart';
import 'subreddit.dart';

class SubredditScreen extends StatelessWidget {
  const SubredditScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Builder(builder: (context) {
          final notifier = context.watch<SubredditNotifierQ>();
          final src = notifier.subreddit.bannerBackgroundImage;
          return SearchField(
            subreddit: 'r/${notifier.name}',
            src: src == '' ? null : src,
            trailing: subredditMenu(context),
          );
        }),
      ),
      body: SubredditWidget(),
    );
  }

  Widget subredditMenu(BuildContext context) {
    return CustomPopupMenuButton(
      icon: IconTheme(data: appBarIconTheme, child: Icon(Icons.more_vert)),
      // icon: Icon(Icons.more_vert),
      items: [
        CustomPopupMenuItem(
          icon: Icon(Icons.visibility_off),
          label: 'Hide Post',
          onTap: () {
            showTodoSnackBar(context); // TODO
          },
        ),
        CustomPopupMenuItem(
          icon: Icon(Icons.report),
          label: 'Report',
          onTap: () {
            showTodoSnackBar(context); // TODO
          },
        ),
        CustomPopupMenuItem(
          icon: Icon(Icons.block),
          label: 'Block user',
          onTap: () {
            showTodoSnackBar(context); // TODO
          },
        ),
      ],
    );
  }
}

class SubredditScreenLoader extends StatelessWidget {
  const SubredditScreenLoader({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<SubredditLoaderNotifierQ>();

    return Loader<SubredditNotifierQ>(
      load: (_) => notifier.loadSubreddit(name),
      data: (_) => notifier.subreddit,
      onData: (_, subreddit) {
        return ChangeNotifierProvider<SubredditNotifierQ>.value(
          value: subreddit,
          child: SubredditScreen(),
        );
      },
    );
  }
}

class SubredditScreenLoaderV2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: DefaultTabController(
          length: 2, // This is the number of tabs.
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  collapsedHeight: 80,
                  flexibleSpace: SearchField(),
                  pinned: true,
                ),

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
                // Home(),
                // Popular(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
