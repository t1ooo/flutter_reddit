import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../notifier/reddir_notifier.dart';
import '../home/submission_tile.v2.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../widget/loader.v2.dart';
// import '../widget/stream_list_builder.dart';

class SavedComments extends StatelessWidget {
  const SavedComments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Padding(
    //   padding: pagePadding,
    //   child: StreamListBuilder(
    //     stream: context.read<CurrentUserNotifier>().savedComments(),
    //     onData: (context, List<Comment> comments) {
    //       return ListView(
    //         children: [
    //           // for (final comment in comments) UserComment(comment: comment),
    //         ],
    //       );
    //     },
    //   ),
    // );
    // return Builder(
    //   builder: (context) {
    //     final notifier = context.watch<CurrentUserNotifierQ>();
    //     WidgetsBinding.instance?.addPostFrameCallback((_) {
    //       notifier.loadSavedComments();
    //     });
    //     final comments = notifier.savedComments;
    //     if (comments == null) {
    //       return Center(child: CircularProgressIndicator());
    //     }

    //     return ListView(
    //       children: [
    //         for (final comment in comments)
    //           ChangeNotifierProvider<CommentNotifierQ>.value(
    //             value: comment,
    //             child: UserComment(),
    //           ),
    //       ],
    //     );
    //   },
    // );

    return Loader<List<SubmissionNotifierQ>>(
      load: (context) => context.watch<UserNotifierQ>().loadSaved(),
      data: (context) => context.watch<UserNotifierQ>().savedSubmissions,
      onData: (context, submissions) {
        return ListView(
          shrinkWrap: true,
          children: [
            for (final sub in submissions)
              ChangeNotifierProvider<SubmissionNotifierQ>.value(
                value: sub,
                child: SubmissionTile(),
              ),
          ],
        );
      },
    );
  }
}
