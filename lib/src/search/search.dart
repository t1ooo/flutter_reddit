import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/submission_tile.v2.dart';
import '../home/submission_tiles.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/reddir_api.dart';
import '../widget/loader.v2.dart';

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

    // final notifier = context.watch<SearchNotifierQ>();
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   notifier.search(query);
    // });
    // final submissions = notifier.submissions;
    // if (submissions == null) {
    //   return Center(child: CircularProgressIndicator());
    // }
    // return SearchSubmissionTiles(
    //   submissions: submissions,
    //   onTypeChanged: (type) {
    //     if (type != null) notifier.search(query, type);
    //   },
    // );

    // return Builder(
    //   builder: (context) {
    //     // print('builder');
    //     final notifier = context.watch<SearchNotifierQ>();
    //     final submissions = notifier.submissions;
    //     return SearchSubmissionTiles(
    //       sort: notifier.sort,
    //       submissions: submissions,
    //       onTypeChanged: (subType) {
    //         print(subType);
    //         notifier.search(query, subType);
    //       },
    //     );
    //   },
    // );

    return Builder(
      builder: (context) {
        final notifier = context.watch<SearchNotifierQ>();
         return GSubmissionTiles<Sort>(
          type: notifier.sort,
          types: Sort.values,
          submissions: notifier.submissions,
          onTypeChanged: (subType) {
            notifier.search(query, subType);
          },
        );
      },
    );

    /* 
    SearchSubmissionTiles(
      submissions: submissions,
      dropdown: CustomDropdownButton(
        value: type,
        values: SubType.values,
        onChanged: onTypeChanged,
      ),
    );
     */

    // return Loader<List<SubmissionNotifierQ>>(
    //   load: (context) => context.watch<SearchNotifierQ>().search(query),
    //   data: (context) => context.watch<SearchNotifierQ>().submissions,
    //   onData: (context, submissions) {
    //     return ListView(shrinkWrap: true, children: [
    //       CustomDropdownButton(
    //         value: type,
    //         values: SubType.values,
    //         onChanged: onTypeChanged,
    //       ),
    //       SizedBox(height: 50),
    //       for (final sub in submissions )
    //         ChangeNotifierProvider<SubmissionNotifierQ>.value(
    //           value: sub,
    //           child: SubmissionTile(activeLink: true),
    //         ),
    //     ]);
    //   },
    // );

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
