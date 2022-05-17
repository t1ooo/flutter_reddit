import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/widget/swipe_to_refresh.dart';
import 'package:provider/provider.dart';

import '../submission_tile/submission_tiles.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/submission_type.dart';
import '../util/snackbar.dart';

class SubredditWidget extends StatelessWidget {
  const SubredditWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifier>();
    final subreddit = notifier.subreddit;

    // TODO: remove ListView
    return ListView(
      shrinkWrap: true,
      children: [
        SwipeToRefresh(
          onRefresh: () => notifier
              .reloadSubmissions()
              .catchError((e) => showErrorSnackBar(context, e)),
          child: GSubmissionTiles<SubType>(
            type: notifier.subType,
            types: SubType.values,
            submissions: notifier.submissions,
            load: notifier.loadSubmissions,
          ),
        ),
      ],
    );
  }
}
