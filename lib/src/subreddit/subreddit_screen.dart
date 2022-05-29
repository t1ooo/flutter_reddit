import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/subreddit_loader_notifier.dart';
import '../notifier/subreddit_notifier.dart';
import '../util/color.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/loader.dart';
import '../widget/sliver_app_bar.dart';
import '../widget/snackbar.dart';
import 'subreddit_about.dart';
import 'subreddit_info.dart';
import 'subreddit_submission.dart';

class SubredditScreen extends StatelessWidget {
  const SubredditScreen({
    Key? key,
    this.name,
  }) : super(key: key);

  final String? name;

  @override
  Widget build(BuildContext context) {
    if (name == null) {
      return _SubredditScreen();
    }

    final notifier = context.read<SubredditLoaderNotifier>();

    return Loader<SubredditNotifier>(
      load: (_) => notifier.loadSubreddit(name!),
      data: (_) => notifier.subreddit,
      onData: (_, subreddit) {
        return ChangeNotifierProvider<SubredditNotifier>.value(
          value: subreddit,
          child: _SubredditScreen(),
        );
      },
    );
  }
}

class _SubredditScreen extends StatelessWidget {
  const _SubredditScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifier>();
    final subreddit = notifier.subreddit;
    final backgroundImage = subreddit.bannerBackgroundImage;
    final backgroundColor = colorFromHex(subreddit.bannerBackgroundColor) ??
        generateColor(subreddit.id);

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              PrimarySliverAppBar(
                flexibleSpace: SpaceBar(
                  leading: AppBarBackButton(),
                  title: SearchForm(subreddit: 'r/${notifier.name}'),
                  backgroundImage: backgroundImage,
                  backgroundColor: backgroundColor,
                  trailing: _subredditMenu(context, notifier),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  SubredditInfo(),
                ]),
              ),
              SliverTabBar(
                tabs: const [
                  Tab(text: 'Posts'),
                  Tab(text: 'About'),
                  Tab(text: 'Menu'),
                ],
              ),
            ];
          },
          body: TabBarView(
            children: const [
              SubredditSubmission(),
              SubredditAbout(),
              Text('todo'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _subredditMenu(BuildContext context, SubredditNotifier notifier) {
    return CustomPopupMenuButton(
      icon: SpaceBarIcon(Icons.more_vert),
      items: [
        CustomPopupMenuItem(
          icon: Icon(Icons.share),
          label: 'Share',
          onTap: () async {
            return notifier.share();
          },
        ),
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
