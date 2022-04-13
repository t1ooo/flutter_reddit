import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/provider.dart';
import 'package:flutter_reddit_prototype/src/widget/custom_future_builder.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import '../reddit_api/subreddit.dart';
import 'subreddit.dart';

class SubredditScreen extends StatelessWidget {
  const SubredditScreen({
    Key? key,
    required this.subreddit,
  }) : super(key: key);

  final Subreddit subreddit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      // body: SubredditWidget(subreddit: subreddit),
      body: MultiProvider(
        providers: [subscriptionNotifierProvider(subreddit.userIsSubscriber)],
        child: SubredditWidget(subreddit: subreddit),
      ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      // body: CustomFutureBuilder(
      //   future: context.read<RedditNotifier>().subreddit(name),
      //   onData: (BuildContext context, Subreddit subreddit) {
      //     return SubredditWidget(subreddit: subreddit);
      //   },
      // ),
      body: CustomFutureBuilder(
        future: context.read<RedditNotifier>().subreddit(name),
        onData: (BuildContext context, Subreddit subreddit) {
          return MultiProvider(
            providers: [
              subscriptionNotifierProvider(subreddit.userIsSubscriber)
            ],
            child: SubredditWidget(subreddit: subreddit),
          );
        },
      ),
    );
  }
}
