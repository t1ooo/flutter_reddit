import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/submission_tiles.v2.dart';
import '../notifier/reddir_notifier.dart';

class Search extends StatelessWidget {
  const Search({
    Key? key,
    required this.query,
  }) : super(key: key);

  final String query;


  @override
  Widget build(BuildContext context) {
    return SubmissionTiles(
      stream: (context, type) =>
          context.read<RedditNotifier>().search(query),
    );
  }
}
