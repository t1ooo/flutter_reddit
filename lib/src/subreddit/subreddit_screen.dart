import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../style/style.dart';
import '../util/color.dart';
import '../util/snackbar.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/loader.dart';
import '../widget/sliver_app_bar.dart';
import '../widget/space_bar.dart';
import 'subreddit.dart';
import 'subreddit_info.dart';

class _SubredditScreen extends StatelessWidget {
  _SubredditScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifier>();
    final backgroundImage = notifier.subreddit.bannerBackgroundImage;
    final backgroundColor = notifier.subreddit.bannerBackgroundColor;
    final subreddit = notifier.subreddit;
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            print(innerBoxIsScrolled);
            return [
              PrimarySliverAppBar(
                flexibleSpace: SpaceBar(
                  leading: AppBarBackButton(),
                  title: SearchForm(subreddit: 'r/${notifier.name}'),
                  src: backgroundImage == '' ? null : backgroundImage,
                  backgroundColor: colorFromHex(backgroundColor) ??
                      generateColor(subreddit.id),
                  trailing: _subredditMenu(context),
                ),
              ),
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
            ];
          },
          body: TabBarView(
            children: [
              SubredditWidget(),
              Text('todo'),
              Text('todo'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _subredditMenu(BuildContext context) {
    return CustomPopupMenuButton(
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

// TODO: merge with SubredditScreen
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
