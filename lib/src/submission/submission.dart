import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../submission_tile/submission_tile.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../widget/loader.dart';
import 'submission_comment.dart';

class SubmissionWidget extends StatelessWidget {
  SubmissionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubmissionNotifierQ>();
    return /* Stack(
      children: [ */
        ListView(
      children: [
        SubmissionTile(
          activeLink: false,
        ),
        SizedBox(height: 50),
        Loader<List<CommentNotifierQ>>(
          load: (_) => notifier.loadComments(),
          data: (_) => notifier.comments,
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
        ),
        // ListView(
        //   shrinkWrap: true,
        //   children: [
        //     for (final comment in notifier.comments)
        //       ChangeNotifierProvider<CommentNotifierQ>.value(
        //         value: comment,
        //         child: SubmissionComment(),
        //       ),
        //   ],
        // ),
        SizedBox(height: 100),
      ],
    );
  }
}
