import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/user_profile/user_comments.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../style/style.dart';
import '../util/color.dart';
import '../util/snackbar.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/sliver_app_bar.dart';
import '../widget/space_bar.dart';
import 'user_about.dart';
import 'user_info.dart';
import 'user_submissions.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<UserNotifier>();
    final user = notifier.user;
    final subreddit = notifier.subreddit;
    final backgroundImage = subreddit.subreddit.bannerBackgroundImage;
    final backgroundColor = subreddit.subreddit.bannerBackgroundColor;
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              PrimarySliverAppBar(
                flexibleSpace: SpaceBar(
                  leading: AppBarBackButton(),
                  src: backgroundImage == '' ? null : backgroundImage,
                  backgroundColor:
                      colorFromHex(backgroundColor) ?? generateColor(user.id),
                  trailing: _userMenu(context),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                UserInfo(),
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
            ];
          },
          body: TabBarView(
            children: [
              UserSubmissions(),
              UserComments(),
              UserAbout(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userMenu(BuildContext context) {
    return CustomPopupMenuButton(
      icon: SpaceBarIcon(Icons.more_vert),
      items: [
        if (kDebugMode)
          CustomPopupMenuItem(
            icon: Icon(Icons.report),
            label: 'Share',
            onTap: () {
              showTodoSnackBar(context); // TODO
            },
          ),
        if (kDebugMode)
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
