import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import '../reddit_api/subreddit.dart';

class Subscriptions extends StatelessWidget {
  const Subscriptions({
    Key? key,
    // this.subreddits,
  }) : super(key: key);

  // final List<Subreddit>? subreddits;

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<RedditNotifier>();
    return ListView(shrinkWrap: true, children: [
      for (final subreddit in notifier.userSubreddits ?? [])
        Text(subreddit.displayName)
    ]);
  }
}
