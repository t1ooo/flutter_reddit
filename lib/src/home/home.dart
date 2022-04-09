import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import 'submission_tiles.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<RedditNotifier>();
    return SubmissionTiles(
      submissions: notifier.frontBest,
      showLocationSelector: false,
    );
  }
}
