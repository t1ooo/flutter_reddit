import 'package:flutter/material.dart';

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
      body: SubredditWidget(subreddit:subreddit),
    );
  }
}
