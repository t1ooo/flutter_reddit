import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/widget/loader.dart';

import 'package:provider/provider.dart';

import '../notifier/auth_notifier.dart';
import '../notifier/collapsible.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/current_user_notifier.dart';
import '../notifier/home_front_notifier.dart';
import '../notifier/home_popular_notifier.dart';
import '../notifier/iterable_sum.dart';
import '../notifier/likable.dart';
import '../notifier/limit.dart';
import '../notifier/list_notifier.dart';
import '../notifier/message_notifier.dart';
import '../notifier/property_listener.dart';
import '../notifier/replyable.dart';
import '../notifier/reportable.dart';
import '../notifier/rule_notifier.dart';
import '../notifier/savable.dart';
import '../notifier/score.dart';
import '../notifier/search_notifier.dart';
import '../notifier/search_subreddits_notifier.dart';
import '../notifier/submission_loader_notifier.dart';
import '../notifier/submission_notifier.dart';
import '../notifier/submissions_notifier.dart';
import '../notifier/subreddit_loader_notifier.dart';
import '../notifier/subreddit_notifier.dart';
import '../notifier/try_mixin.dart';
import '../notifier/user_loader_notifier.dart';
import '../notifier/user_notifier.dart';
import '../style.dart';
import '../util/color.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/sliver_app_bar.dart';
import '../widget/snackbar.dart';
import 'user_about.dart';
import 'user_comments.dart';
import 'user_info.dart';
import 'user_submissions.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({
    Key? key,
    this.name,
  }) : super(key: key);

  final String? name;

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  Widget body(BuildContext context) {
    if (name == null) {
      return _UserProfileScreen();
    }

    final notifier = context.read<UserLoaderNotifier>();

    return Loader<UserNotifier>(
      load: (_) => notifier.loadUser(name!),
      data: (_) => notifier.user,
      onData: (_, user) {
        return ChangeNotifierProvider<UserNotifier>.value(
          value: user,
          child: _UserProfileScreen(),
        );
      },
    );
  }
}

class _UserProfileScreen extends StatelessWidget {
  const _UserProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<UserNotifier>();
    final subreddit = notifier.subreddit.subreddit;
    final backgroundImage = subreddit.bannerBackgroundImage;
    final backgroundColor = colorFromHex(subreddit.bannerBackgroundColor) ??
        generateColor(notifier.user.id);

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              PrimarySliverAppBar(
                flexibleSpace: SpaceBar(
                  leading: AppBarBackButton(),
                  src: backgroundImage,
                  backgroundColor: backgroundColor,
                  trailing: _userMenu(context, notifier),
                ),
              ),
              SliverList(delegate: SliverChildListDelegate([UserInfo()])),
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                flexibleSpace: TabBar(
                  tabs: [
                    Tab(text: 'Posts'),
                    Tab(text: 'Comments'),
                    Tab(text: 'About'),
                  ],
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

  Widget _userMenu(BuildContext context, UserNotifier notifier) {
    final user = notifier.user;

    return CustomPopupMenuButton(
      icon: SpaceBarIcon(Icons.more_vert),
      items: [
        CustomPopupMenuItem(
          icon: Icon(Icons.share),
          label: 'Share',
          onTap: () async {
            return notifier.subreddit.share();
          },
        ),
        CustomPopupMenuItem(
          icon: Icon(
            user.isBlocked ? Icons.person_add : Icons.block,
          ),
          label: user.isBlocked ? 'Unblock' : 'Block',
          onTap: () {
            return (user.isBlocked ? notifier.unblock() : notifier.block())
                .catchError((e) => showErrorSnackBar(context, e));
          },
        ),
      ],
    );
  }
}
