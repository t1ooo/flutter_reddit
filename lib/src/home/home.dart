import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import '../reddit_api/submission.dart';
import '../widget/stream_list_builder.dart';
import 'submission_tile.dart';
import 'submission_tiles.v2.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   final notifier = context.watch<SubTypeNotifier>();
  //   return StreamListBuilder(
  //     stream: context.read<RedditNotifier>().front(type: notifier.type),
  //     onData: (context, List<Submission> submissions) {
  //       return SubmissionTiles(
  //         type: notifier.type,
  //         onTypeChanged: (type) {
  //           if (type != null) notifier.type = type;
  //         },
  //         submissions: submissions,
  //         // showLocationSelector: false,
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SubmissionTiles(
      stream: (context, type) =>
          context.read<RedditNotifier>().front(type: type),
    );
  }
}
