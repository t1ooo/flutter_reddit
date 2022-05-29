import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/search_notifier.dart';
import '../reddit_api/reddit_api.dart';
import '../submission_tile/submission_tiles.dart';
import '../widget/pull_to_refresh.dart';
import '../widget/snackbar.dart';

class SearchPosts extends StatelessWidget {
  const SearchPosts({
    Key? key,
    required this.query,
    this.subreddit,
  }) : super(key: key);

  final String query;
  final String? subreddit;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SearchNotifier>();

    return PullToRefresh(
      onRefresh: () => notifier
          .reloadSearch()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: SubmissionTiles<Sort>(
        type: notifier.sort,
        types: Sort.values,
        submissions: notifier.submissions,
        load: (subType) => subreddit != null
            ? notifier.search(query, subType, subreddit!)
            : notifier.search(query, subType),
      ),
    );
  }
}
