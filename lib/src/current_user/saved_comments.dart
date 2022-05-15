import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/util/snackbar.dart';
import 'package:flutter_reddit_prototype/src/widget/swipe_to_refresh.dart';
import 'package:provider/provider.dart';

import '../submission/submission_comment.dart';
// ignore: unused_import
import '../submission_tile/submission_tile.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../widget/loader.dart';
import 'saved_comment.dart';

class SavedComments extends StatelessWidget {
  const SavedComments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserNotifierQ>();

    return SwipeToRefresh(
      onRefresh: () => notifier
          .reloadSaved()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: Loader<List<CommentNotifierQ>>(
        load: (_) => notifier.loadSaved(),
        data: (_) => notifier.savedComments,
        onData: (_, comments) {
          return ListView(
            shrinkWrap: true,
            children: [
              for (final comment in comments)
                ChangeNotifierProvider<CommentNotifierQ>.value(
                  value: comment,
                  child: SavedComment(),
                ),
            ],
          );
        },
      ),
    );
  }
}
