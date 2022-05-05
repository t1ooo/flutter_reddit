import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:flutter_reddit_prototype/src/provider.dart';
import 'package:flutter_reddit_prototype/src/widget/custom_future_builder.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/subreddit.dart';
import '../style/style.dart';
import '../util/color.dart';
import '../util/snackbar.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/loader.dart';
import '../widget/sliver_app_bar.dart';
import '../widget/space_bar.dart';
import '../widget/subscribe_button.dart';
import 'subreddit.dart';
import 'subreddit_info.dart';

// class SubredditScreen extends StatelessWidget {
//   const SubredditScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Builder(builder: (context) {
//           final notifier = context.watch<SubredditNotifierQ>();
//           final src = notifier.subreddit.bannerBackgroundImage;
//           return SearchField(
//             subreddit: 'r/${notifier.name}',
//             src: src == '' ? null : src,
//             trailing: _subredditMenu(context),
//           );
//         }),
//       ),
//       body: SubredditWidget(),
//     );
//   }

//   Widget _subredditMenu(BuildContext context) {
//     return CustomPopupMenuButton(
//       icon: IconTheme(data: appBarIconTheme, child: Icon(Icons.more_vert)),
//       // icon: Icon(Icons.more_vert),
//       items: [
//         CustomPopupMenuItem(
//           icon: Icon(Icons.visibility_off),
//           label: 'Hide Post',
//           onTap: () {
//             showTodoSnackBar(context); // TODO
//           },
//         ),
//         CustomPopupMenuItem(
//           icon: Icon(Icons.report),
//           label: 'Report',
//           onTap: () {
//             showTodoSnackBar(context); // TODO
//           },
//         ),
//         CustomPopupMenuItem(
//           icon: Icon(Icons.block),
//           label: 'Block user',
//           onTap: () {
//             showTodoSnackBar(context); // TODO
//           },
//         ),
//       ],
//     );
//   }
// }

class SubredditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifierQ>();
    final backgroundImage = notifier.subreddit.bannerBackgroundImage;
    final backgroundColor = notifier.subreddit.bannerBackgroundColor;
    final subreddit = notifier.subreddit;
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      // ),
      body: DefaultTabController(
        length: 3, // This is the number of tabs.
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            print(innerBoxIsScrolled);
            return [
              PrimarySliverAppBar(
                // // stretch: true,
                // pinned: true,
                // // snap: true,
                // primary: false,
                // // leading: Icon(Icons.back_hand),
                // automaticallyImplyLeading: false,
                // collapsedHeight: 120,
                // expandedHeight: appBarExpandedHeight,
                // // expandedHeight: 500,
                // // leading: Padding(
                // //   padding: const EdgeInsets.only(top:10),
                // //   child: IconTheme(
                // //         data: appBarIconTheme,
                // //         child: Icon(Icons.arrow_back),
                // //       ),
                // // ),
                // flexibleSpace: SearchField(
                //   subreddit: 'r/${notifier.name}',
                //   src: backgroundImage == '' ? null : backgroundImage,
                //   backgroundColor: colorFromHex(backgroundColor),
                //   // backgroundColor: colorFromHex('#005ba1'),
                //   leading: SearchAppBarBackButton.black(),
                //   trailing: _subredditMenu(context),
                // ),
                flexibleSpace: SpaceBar(
                  leading: AppBarBackButton(),
                  title: SearchForm(),
                  src: backgroundImage == '' ? null : backgroundImage,
                  backgroundColor: colorFromHex(backgroundColor) ??
                      generateColor(subreddit.id),
                  trailing: _subredditMenu(context),
                ),

                // title: Text('123'),
                // bottom: PreferredSize(preferredSize: Size(100, 100),child: Text('123123')),
                // flexibleSpace: FlexibleSpaceBar(
                //   background: Column(
                //     children: [
                //       // Container(
                //       //     height: appBarExpandedHeight / 2,
                //       //     color: Colors.yellow),
                //       // Container(
                //       //     height: appBarExpandedHeight / 2,
                //       //     color: Colors.red),
                //       Container(
                //         height: 500,
                //         child: SearchField(
                //           subreddit: 'r/${notifier.name}',
                //           src: backgroundImage == '' ? null : backgroundImage,
                //           backgroundColor: colorFromHex(backgroundColor),
                //           // backgroundColor: colorFromHex('#005ba1'),
                //           leading: SearchAppBarBackButton.black(),
                //           trailing: _subredditMenu(context),
                //         ),
                //       ),
                //       // Container(
                //       //   height: 400,
                //       //   child: SubredditInfo(),
                //       // ),
                //     ],
                //   ),
                // ),
              ),

              // SliverAppBar(
              //   collapsedHeight: 400,
              //   // pinned: true,
              //   automaticallyImplyLeading: false,
              //   flexibleSpace:  Container(
              //     width: 400,
              //     child: SubredditInfo()),

              // ),

              SliverList(
                  delegate: SliverChildListDelegate([
                SubredditInfo(),
              ])),

              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  width: 100,
                  child: TabBar(
                    indicatorColor: selectedColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(text: 'Posts'),
                      Tab(text: 'About'),
                      Tab(text: 'Menu'),
                    ],
                  ),
                ),
              ),

              // SliverList(
              //     delegate: SliverChildListDelegate([
              //   SliverAppBar(
              //     automaticallyImplyLeading: false,
              //     flexibleSpace: Container(width: 100, child: Text('test')),
              //   ),
              // ])),

              // SliverAppBar(
              //   automaticallyImplyLeading: false,
              //   flexibleSpace: Container(width: 100, child: Text('test')),
              // ),

              // SliverOverlapAbsorber(
              //   handle:
              //       NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              //   sliver: SliverSafeArea(
              //     top: false,
              //     sliver: SliverAppBar(
              //       floating: true,
              //       primary:  false,
              //       pinned: true,
              //       // leading: Icon(Icons.back_hand),
              //       automaticallyImplyLeading: false,
              //       toolbarHeight: 0,
              //       // collapsedHeight: 0,
              //       // expandedHeight: appBarExpandedHeight,
              //       expandedHeight: 400,
              //       flexibleSpace: SingleChildScrollView(child:SubredditInfo()),
              //     ),
              //   ),
              // ),

              // SliverAppBar(
              //   floating: true,
              //   primary: true,
              //   pinned: true,

              //   // leading: Icon(Icons.back_hand),
              //   automaticallyImplyLeading: false,
              //   toolbarHeight: 0,
              //   collapsedHeight: 0,
              //   // expandedHeight: appBarExpandedHeight,
              //   expandedHeight: 400,
              //   flexibleSpace: SingleChildScrollView(child: SubredditInfo()),
              // ),

              // SliverPersistentHeader(delegate: SliverPersistentHeaderDelegate()),

              // SliverList(
              //   delegate: SliverChildBuilderDelegate((_, __) {
              //     return SubredditInfo();
              //   }, childCount: 1),
              // ),

              /*  SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Row(
                        children: [
                          SizedBox(height: 100),
                          if (subreddit.communityIcon != '')
                            CircleAvatar(
                              radius: 16, // Image radius
                              foregroundImage: CachedNetworkImageProvider(
                                subreddit.communityIcon,
                                cacheManager: context.read<CacheManager>(),
                              ),
                              onForegroundImageError: (e, _) => log('$e'),
                            ),
                          SizedBox(width: 10),
                          Text(subreddit.displayNamePrefixed,
                              textScaleFactor: 2),
                          Spacer(),
                          // ElevatedButton(onPressed: () {}, child: Icon(Icons.doorbell)),
                          // SizedBox(width: 10),
                          SubscribeButton(),
                        ],
                      ),
                      // SizedBox(height: 10),
                      Text('${subreddit.subscribers} members'),
                      SizedBox(height: 20),
                      Text(subreddit.publicDescription),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
               */
            ];
          },
          body: TabBarView(
            children: [
              SubredditWidget(),
              Text('todo'),
              Text('todo'),
            ],
          ),
          // body: SubredditWidget(),
          // body:Card(color: colorFromHex('#005ba1')),
          // body:Card(color: Color(0xFF005ba1)),

          // ListView(
          // children: [
          //   for (var i = 0; i < 100; i++)
          //     ListTile(
          //       leading: Text('$i'),
          //       title: Text('Some Text'),
          //     )
          // ],
          // ),
        ),
      ),
    );
  }

  Widget _subredditMenu(BuildContext context) {
    return CustomPopupMenuButton(
      // icon: IconTheme(data: appBarIconTheme, child: Icon(Icons.more_vert)),
      icon: SpaceBarIcon(Icons.more_vert),
      items: [
        if (kDebugMode)
          CustomPopupMenuItem(
            icon: Icon(Icons.circle),
            label: 'Add to Custom Feed',
            onTap: () {
              showTodoSnackBar(context); // TODO
            },
          ),
        if (kDebugMode)
          CustomPopupMenuItem(
            icon: Icon(Icons.circle),
            label: 'Community info',
            onTap: () {
              showTodoSnackBar(context); // TODO
            },
          ),
        if (kDebugMode)
          CustomPopupMenuItem(
            icon: Icon(Icons.circle),
            label: 'Change user flair',
            onTap: () {
              showTodoSnackBar(context); // TODO
            },
          ),
        if (kDebugMode)
          CustomPopupMenuItem(
            icon: Icon(Icons.circle),
            label: 'Contact mods',
            onTap: () {
              showTodoSnackBar(context); // TODO
            },
          ),
        if (kDebugMode)
          CustomPopupMenuItem(
            icon: Icon(Icons.circle),
            label: 'Add to home screen',
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
