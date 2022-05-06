import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:flutter_reddit_prototype/src/widget/sliver_app_bar.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../subreddit/subreddit_icon.dart';
import '../util/snackbar.dart';
import '../widget/list.dart';
import '../widget/loader.dart';
import '../widget/space_bar.dart';

class ChooseSubredditScreen extends StatelessWidget {
  ChooseSubredditScreen({
    Key? key,
    // required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            PrimarySliverAppBar(
              collapsed: true,
              flexibleSpace: SpaceBar(
                leading: AppBarBackButton(),
                title: AppBarTitle('Choose as community'),
              ),
            ),
          ];
        },
        body:  _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final notifier = context.read<CurrentUserNotifierQ>();

    return Loader<List<SubredditNotifierQ>>(
      load: (_) => notifier.loadSubreddits(),
      data: (_) => notifier.subreddits,
      onData: (_, subreddits) {
        return CustomListView(
          // shrinkWrap: true,
          children: [
            ListTitle('JOINED'),
            for (final subreddit in subreddits)
              ListTile(
                leading: SizedBox.square(dimension: 30, child: SubredditIcon(icon:subreddit.subreddit.communityIcon)),
                title: Text(subreddit.subreddit.displayNamePrefixed),
              )
              // Text(subreddit.name)
          ],
        );
      },
    );
  }
}
