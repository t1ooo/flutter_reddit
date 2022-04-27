import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import '../style/style.dart';
// import '../widget/stream_list_builder.dart';
// import 'submission_tile.dart';
import 'submission_tiles.dart';

class Popular extends StatelessWidget {
  const Popular({Key? key}) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   // final notifier = context.read<RedditNotifier>();
  //   // return SubmissionTiles(
  //   //   submissions: notifier.popular,
  //   // );
  //   // return CustomStreamBuilder(
  //   //   stream: context.read<RedditNotifier>().popular(),
  //   //   onData: (context, Submission submission) {
  //   //     return Padding(
  //   //       padding: scrollPadding,
  //   //       child: SubmissionTile(
  //   //         submission: submission,
  //   //         activeLink: true,
  //   //       ),
  //   //     );
  //   //   },
  //   // );
  //   return StreamListBuilder(
  //     stream: context.read<RedditNotifier>().popular(),
  //     onData: (context, List<Submission> submissions) {
  //       return SubmissionTiles(
  //         onTypeChanged: (type) {
  //           // TODO
  //         },
  //         submissions: submissions,
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // return SubmissionTiles<SubType,PopularSubmissionsNotifier>(
    //   pageStorageKey: PageStorageKey('popular'),
    // );

    // return SubmissionTiles(
    //   pageStorageKey: PageStorageKey('PopularSubmissions'),
    //   controller: context.read<PopularSubmissionsNotifier>(),
    // );

    return Builder(builder: (context) {
      final notifier = context.watch<HomePopularNotifierQ>();
      final submissions = notifier.submissions;
      return SubmissionTiles(
        type: notifier.subType,
        submissions: submissions,
        onTypeChanged: (subType) {
          print(subType);
          notifier.loadSubmissions(subType);
        },
      );
    });

    // return SubmissionTiles(
    //   pageStorageKey: PageStorageKey('popular'),
    //   stream: (context, type) =>
    //       context.read<CurrentUserNotifier>().popular(type: type),
    // );

    // return MultiProvider(
    //   providers: [
    //     submissionTypeNotifierProvider(),
    //   ],
    //   child: SubmissionTiles(
    //     stream: (context, type) =>
    //         context.read<CurrentUserNotifier>().popular(type: type),
    //   ),
    // );
  }
}
