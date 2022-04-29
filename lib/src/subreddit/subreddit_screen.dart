import 'package:flutter/material.dart';
// import 'package:flutter_reddit_prototype/src/provider.dart';
import 'package:flutter_reddit_prototype/src/widget/custom_future_builder.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/subreddit.dart';
import '../widget/loader.dart';
import 'subreddit.dart';

class SubredditScreen extends StatelessWidget {
  const SubredditScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SubredditWidget(),
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
    final notifier = context.read<SubredditLoaderNotifierQ>();
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Loader<SubredditNotifierQ>(
        load: (_) => notifier.loadSubreddit(name),
        data: (_) => notifier.subreddit,
        onData: (_, subreddit) {
          return ChangeNotifierProvider<SubredditNotifierQ>.value(
            value: subreddit,
            child: SubredditWidget(),
          );
        },
      ),
    );
  }
}
