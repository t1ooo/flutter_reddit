import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../submission_tile/submission_tile.dart';
import '../submission_tile/submission_tiles.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/reddir_api.dart';
import '../widget/loader.dart';

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
    final notifier = context.watch<SearchNotifierQ>();
    return GSubmissionTiles<Sort>(
      type: notifier.sort,
      types: Sort.values,
      submissions: notifier.submissions,
      onTypeChanged: (subType) {
        subreddit != null
          ? notifier.search(query, subType, subreddit!)
          : notifier.search(query, subType);
      },
    );
  }
}
