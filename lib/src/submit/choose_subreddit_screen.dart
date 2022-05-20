import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/widget/sliver_app_bar.dart';
import 'package:provider/provider.dart';

import '../notifier/auth_notifier.dart';
import '../notifier/collapse_mixin.dart';
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
import '../notifier/search_subreddits.dart';
import '../notifier/submission_loader_notifier.dart';
import '../notifier/submission_notifier.dart';
import '../notifier/submissions_notifier.dart';
import '../notifier/subreddit_loader_notifier.dart';
import '../notifier/subreddit_notifier.dart';
import '../notifier/try_mixin.dart';
import '../notifier/user_loader_notifier.dart';
import '../notifier/user_notifier.dart';
import '../subreddit/subreddit_icon.dart';
import '../widget/list.dart';
import '../widget/loader.dart';

class ChooseSubredditScreen extends StatelessWidget {
  ChooseSubredditScreen({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  final void Function(SubredditNotifier) onChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
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
        body: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final notifier = context.read<CurrentUserNotifier>();

    return Loader<List<SubredditNotifier>>(
      load: (_) => notifier.loadSubreddits(),
      data: (_) => notifier.subreddits,
      onData: (_, subreddits) {
        return CustomListView(
          children: [
            ListTitle('JOINED'),
            for (final subreddit in subreddits)
              ListTile(
                onTap: () {
                  onChanged(subreddit);
                  Navigator.of(context).pop();
                },
                leading: SizedBox.square(
                  dimension: 40,
                  child: SubredditIcon(icon: subreddit.subreddit.communityIcon),
                ),
                title: Text(subreddit.subreddit.displayNamePrefixed),
              )
          ],
        );
      },
    );
  }
}
