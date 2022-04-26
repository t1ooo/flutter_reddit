import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/submission_tiles.dart';
import '../notifier/reddir_notifier.dart';
import '../notifier/reddir_notifier.v4_1.dart';
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

    // return SubmissionTiles(
    // pageStorageKey: PageStorageKey('search'),
    // controller: context.read<SearchSubmissionsNotifier>(),
    // );

    final notifier = context.watch<SearchNotifierQ>();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      notifier.search(query);
    });
    final submissions = notifier.submissions;
    if (submissions == null) {
      return Center(child: CircularProgressIndicator());
    }
    return SearchSubmissionTiles(
      submissions: submissions,
      onTypeChanged: (type) {
        if (type != null) notifier.search(query, type);
      },
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
