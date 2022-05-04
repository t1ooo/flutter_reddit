import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/user_profile/user_comments.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../style/style.dart';
import '../subreddit/subreddit_info.dart';
import '../util/color.dart';
import '../util/date_time.dart';
import '../util/snackbar.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/network_image.dart';
import '../widget/sliver_app_bar.dart';
import '../widget/space_bar.dart';
import '../widget/subscribe_button.dart';
import 'user_about.dart';
import 'user_info.dart';
import 'user_submissions.dart';

// class UserProfile extends StatelessWidget {
//   const UserProfile({
//     Key? key,
//     required this.isCurrentUser,
//   }) : super(key: key);

//   final bool isCurrentUser;

//   @override
//   Widget build(BuildContext context) {
//     final notifier = context.read<UserNotifierQ>();
//     final user = notifier.user;
//     return DefaultTabController(
//       length: 3,
//       child: Column(
//         children: [
//           Padding(
//             padding: pagePadding,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: topPadding),
//                 Row(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           width: iconSize,
//                           height: iconSize,
//                           // child: Image.network(user.iconImg),
//                           child: CustomNetworkImageBuilder(user.iconImg),
//                         ),
//                       ],
//                     ),
//                     SizedBox(width: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(user.name, textScaleFactor: 2),
//                         Text(user.subreddit.displayNamePrefixed),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 if (isCurrentUser)
//                   ElevatedButton(onPressed: () {}, child: Text('EDIT'))
//                 else
//                   Row(
//                     // alignment: MainAxisAlignment.start,
//                     children: [
//                       ElevatedButton(onPressed: () {}, child: Text('CHAT')),
//                       SizedBox(width: 10),
//                       ChangeNotifierProvider<SubredditNotifierQ>.value(
//                         value: notifier.subreddit,
//                         child: SubscribeButton(isUserPage: true),
//                       ),
//                     ],
//                   ),
//                 SizedBox(height: 20),
//                 Text(
//                     '${user.totalKarma} karma • ${formatDateTime(user.created)} • ${'${user.subreddit.subscribers} followers'}'),
//                 SizedBox(height: 10),
//                 Text(user.subreddit.publicDescription),
//                 SizedBox(height: 20),
//               ],
//             ),
//           ),
//           Container(
//             child: TabBar(
//               labelColor: Colors.blue,
//               tabs: [
//                 Tab(child: Text('Posts')),
//                 Tab(child: Text('Comments')),
//                 Tab(child: Text('About')),
//               ],
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               children: [
//                 UserSubmissions(),
//                 UserComments(),
//                 UserAbout(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class UserProfile extends StatelessWidget {
  // class UserProfile extends StatelessWidget {
//   const UserProfile({
//     Key? key,
//     required this.isCurrentUser,
//   }) : super(key: key);

//   final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<UserNotifierQ>();
    final user = notifier.user;
    final subreddit = notifier.subreddit;
    final backgroundImage = subreddit.subreddit.bannerBackgroundImage;
    final backgroundColor = subreddit.subreddit.bannerBackgroundColor;
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      // ),
      body: DefaultTabController(
        length: 3, // This is the number of tabs.
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            // print(innerBoxIsScrolled);
            return [
              PrimarySliverAppBar(
                // stretch: true,
                // pinned: true,
                // // snap: true,
                // primary: false,
                // // leading: Icon(Icons.back_hand),
                // automaticallyImplyLeading: false,
                // collapsedHeight: 120,
                // expandedHeight: appBarExpandedHeight,
                // expandedHeight: 500,
                // leading: Padding(
                //   padding: const EdgeInsets.only(top:10),
                //   child: IconTheme(
                //         data: appBarIconTheme,
                //         child: Icon(Icons.arrow_back),
                //       ),
                // ),
                // flexibleSpace: SearchField(
                //   subreddit: 'r/${subreddit.name}',
                //   src: backgroundImage == '' ? null : backgroundImage,
                //   backgroundColor:
                //       colorFromHex(backgroundColor) ?? generateColor(user.name),
                //   // backgroundColor: colorFromHex('#005ba1'),
                //   leading: SearchSearchBackButton.black(),
                //   trailing: _userMenu(context),
                //   showSearchForm: false,
                // ),

                 flexibleSpace: SpaceBar(
                  leading: SearchBackButton(),
                  // title: SearchForm(subreddit: 'r/${subreddit.name}',),
                  src: backgroundImage == '' ? null : backgroundImage,
                  backgroundColor: colorFromHex(backgroundColor) ?? generateColor(user.name),
                  trailing: _userMenu(context),
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
                //           leading: SearchSearchBackButton.black(),
                //           trailing: _userMenu(context),
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
                UserInfo(),
                // ChangeNotifierProvider<SubredditNotifierQ>.value(
                //   value: subreddit,
                //   child: UserInfo(),
                // ),
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
                      Tab(text: 'Comments'),
                      Tab(text: 'About'),
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
              UserSubmissions(),
              UserComments(),
              UserAbout(),
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

  Widget _userMenu(BuildContext context) {
    return CustomPopupMenuButton(
      // icon: IconTheme(data: appBarIconTheme, child: Icon(Icons.more_vert)),
      icon: SpaceBarIcon(Icons.more_vert),
      items: [
        CustomPopupMenuItem(
          icon: Icon(Icons.report),
          label: 'Share',
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
