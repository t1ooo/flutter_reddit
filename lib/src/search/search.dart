import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/submission_tiles.v4.dart';
import '../notifier/reddir_notifier.dart';
import '../reddit_api/reddir_api.dart';

class Search extends StatelessWidget {
  const Search({
    Key? key,
    required this.query,
  }) : super(key: key);

  final String query;

  @override
  Widget build(BuildContext context) {
    // return SubmissionTiles(
    //   stream: (context, type) =>
    //       context.read<RedditNotifier>().search(query),
    // );
    // return ChangeNotifierProvider(
    //   create: (BuildContext context) => FilterNotifier<Sort>(Sort.relevance),
    //   child: SubmissionTiles<Sort>(
    //     stream: (context, type) => context.read<RedditNotifier>().search(query),
    //   ),
    // );

    // return SubmissionTiles(
    //   stream: (context, type) =>
    //       context.read<RedditNotifier>().search(query),
    // );

     return SubmissionTiles<SearchSubmissionsNotifier>(
      pageStorageKey: PageStorageKey('home'),
    );
  }
}
