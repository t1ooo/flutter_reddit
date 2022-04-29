import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../submission_tile/submission_tile.dart';
import '../submission_tile/submission_tiles.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/reddir_api.dart';
import '../widget/loader.dart';

class Search extends StatelessWidget {
  const Search({
    Key? key,
    required this.query,
  }) : super(key: key);

  final String query;

  @override
  Widget build(BuildContext context) {
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
  }
}
