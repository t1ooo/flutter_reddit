import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import '../reddit_api/submission.dart';
import '../widget/stream_list_builder.dart';
import 'submission_tile.dart';
import 'submission_tiles.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubmissionTypeNotifier>();
    // return SubmissionTiles(
    //   submissions: notifier.frontBest,
    //   showLocationSelector: false,
    // );
    // return CustomStreamBuilder(
    //   stream: context.read<RedditNotifier>().frontBest(),
    //   onData: (context, Submission submission) {
    //     return Padding(
    //       padding: scrollPadding,
    //       child: SubmissionTile(
    //         submission: submission,
    //         activeLink: true,
    //       ),
    //     );
    //   },
    // );
    print(notifier.type);
    return StreamListBuilder(
      stream: context.read<RedditNotifier>().frontBest(type: notifier.type),
      onData: (context, List<Submission> submissions) {
        return SubmissionTiles(
          type: notifier.type,
          onTypeChanged: (type) {
            if(type != null) notifier.type = type;
          },
          submissions: submissions,
          // showLocationSelector: false,
        );
      },
    );
  }
}
