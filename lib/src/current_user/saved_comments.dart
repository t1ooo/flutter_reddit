import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../submission/submission_comment.dart';
// ignore: unused_import
import '../submission_tile/submission_tile.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../widget/loader.dart';

class SavedComments extends StatelessWidget {
  const SavedComments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserNotifierQ>();
    return Loader<List<CommentNotifierQ>>(
      load: (_) => notifier.loadSaved(),
      data: (_) => notifier.savedComments,
      onData: (_, comments) {
        return ListView(
          shrinkWrap: true,
          children: [
            for (final comment in comments)
              ChangeNotifierProvider<CommentNotifierQ>.value(
                value: comment,
                child: SubmissionComment(),
              ),
          ],
        );
      },
    );

    /* return Builder(
      builder: (context) {
        final submissions =
            context.select<UserNotifierQ, List<SubmissionNotifierQ>?>(
                (v) => v.savedSubmissions);
        if (submissions == null) {
          return CircularProgressIndicator();
        }
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
    ); */
  }
}
