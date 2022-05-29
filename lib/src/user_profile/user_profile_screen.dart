import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/user_loader_notifier.dart';
import '../notifier/user_notifier.dart';
import '../util/color.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/loader.dart';
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
                  backgroundImage: backgroundImage,
                  backgroundColor: backgroundColor,
                  trailing: _userMenu(context, notifier),
                ),
              ),
              SliverList(delegate: SliverChildListDelegate([UserInfo()])),
              SliverTabBar(
                tabBar: TabBar(
                  tabs: const [
                    Tab(text: 'Posts'),
                    Tab(text: 'Comments'),
                    Tab(text: 'About'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: const [
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
          onTap: () => notifier.subreddit.share(),
        ),
        CustomPopupMenuItem(
          icon: Icon(
            user.isBlocked ? Icons.person_add : Icons.block,
          ),
          label: user.isBlocked ? 'Unblock' : 'Block',
          onTap: () => notifier
              .block(!user.isBlocked)
              .catchError((e) => showErrorSnackBar(context, e)),
        ),
      ],
    );
  }
}
