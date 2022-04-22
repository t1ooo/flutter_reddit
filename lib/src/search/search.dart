import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/submission_tiles.v5.dart';
import '../notifier/reddir_notifier.dart';

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

    return SubmissionTiles(
      pageStorageKey: PageStorageKey('search'),
      controller: context.read<SearchSubmissionsNotifier>(),
    );

    // return Builder(builder: (context) {
    //   final notifier = context.read<SearchSubmissionsNotifier>();
    //   notifier.query = query;
    //   return SubmissionTiles(
    //     pageStorageKey: PageStorageKey('search'),
    //     controller: notifier,
    //   );
    // });
  }
}
