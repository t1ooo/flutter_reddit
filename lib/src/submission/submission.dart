import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/comment_notifier.dart';
import '../notifier/submission_notifier.dart';
import '../submission_tile/submission_tile.dart';
import '../widget/list.dart';
import '../widget/loader.dart';
import '../widget/snackbar.dart';
import '../widget/swipe_to_refresh.dart';
import 'submission_comment.dart';

class SubmissionWidget extends StatelessWidget {
  const SubmissionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubmissionNotifier>();

    return SwipeToRefresh(
      onRefresh: () => notifier
          .reloadSubmission()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: CustomListView(
        children: [
          SubmissionTile(fullpage: true),
          SizedBox(height: 50),
          Loader<List<CommentNotifier>>(
            load: (_) => notifier.loadComments(),
            data: (_) => notifier.comments,
            onData: (_, comments) {
              return CustomListView(
                shrinkWrap: true,
                children: [
                  for (final comment in comments)
                    ChangeNotifierProvider<CommentNotifier>.value(
                      value: comment,
                      child: SubmissionComment(),
                    ),
                ],
              );
            },
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
