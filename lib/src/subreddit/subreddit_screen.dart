import 'package:flutter/material.dart';
// import 'package:flutter_reddit_prototype/src/provider.dart';
import 'package:flutter_reddit_prototype/src/widget/custom_future_builder.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/subreddit.dart';
import 'subreddit.v2.dart';

class SubredditScreen extends StatelessWidget {
  const SubredditScreen({
    Key? key,
    // required this.subreddit,
  }) : super(key: key);

  // final SubredditNotifierQ subreddit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      // body: SubredditWidget(subreddit: subreddit),
      body: SubredditWidget(),
      // body: ChangeNotifierProvider<SubredditNotifierQ>.value(
          // value: subreddit, child: SubredditWidget()),
      // body: MultiProvider(
      //   providers: [subscriptionNotifierProvider(subreddit.userIsSubscriber)],
      //   child: SubredditWidget(subreddit: subreddit),
      // ),
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
      body: Builder(builder: (context) {
        final notifier = context.watch<SubredditLoaderNotifierQ>();
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          notifier.loadSubreddit(name);
        });
        final subreddit = notifier.subreddit;
        if (subreddit == null) {
          return Center(child: CircularProgressIndicator());
        }

        return ChangeNotifierProvider<SubredditNotifierQ>.value(
            value: subreddit, child: SubredditWidget());
      }),
    );
  }
}
