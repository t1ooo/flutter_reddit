import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../notifier/reddir_notifier.dart';
// import '../provider.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import 'submission_tiles.dart';

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

  /* return SubmissionTiles<SubType,FrontSubmissionsNotifier>(
      pageStorageKey: PageStorageKey('home'),
      stream: () => {}
      value:
      values:
  ); */

  @override
  Widget build(BuildContext context) {
    // context.watch<FrontSubmissionsNotifier>();
    // return SubmissionTiles<SubType,FrontSubmissionsNotifier>(
    //   pageStorageKey: PageStorageKey('home'),
    // );

    // return SubmissionTiles(
    //   pageStorageKey: PageStorageKey('FrontSubmissions'),
    //   controller: context.read<FrontSubmissionsNotifier>(),
    // );

    // return Loader<List<CommentNotifierQ>?, String?>(
    //     load: () => context.read<HomeFrontNotifierQ>().loadSubmissions(),
    //     data: () => context.read<HomeFrontNotifierQ>().comments,
    //     builder: (context, comments, load) {
    //       if (comments == null) {
    //         return Center(child: CircularProgressIndicator());
    //       }
    //       return ListView(
    //         children: [
    //           for (final comment in comments)
    //             ChangeNotifierProvider<CommentNotifierQ>.value(
    //               value: comment,
    //               child: UserComment(),
    //             ),
    //         ],
    //       );
    //     },
    //   );

    return Builder(
      builder: (context) {
        final notifier = context.watch<HomeFrontNotifierQ>();
        final submissions = notifier.submissions;
        return SubmissionTiles(
          type: notifier.subType,
          submissions: submissions,
          onTypeChanged: (subType) {
            // print(subType);
            notifier.loadSubmissions(subType);
          },
        );
      },
    );

    // return SubmissionTiles(
    //   pageStorageKey: PageStorageKey('home'),
    //   stream: (context, type) =>
    //       context.read<CurrentUserNotifier>().front(type: type),
    // );

    // return MultiProvider(
    //   providers: [
    //     submissionTypeNotifierProvider(),
    //   ],
    //   child: SubmissionTiles(
    //     stream: (context, type) =>
    //         context.read<CurrentUserNotifier>().front(type: type),
    //   ),
    // );
  }
}
