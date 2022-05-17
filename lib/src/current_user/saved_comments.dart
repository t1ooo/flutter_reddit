import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/widget/snackbar.dart';
import 'package:flutter_reddit_prototype/src/widget/swipe_to_refresh.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../widget/loader.dart';
import 'saved_comment.dart';

class SavedComments extends StatelessWidget {
  const SavedComments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserNotifier>();

    return SwipeToRefresh(
      onRefresh: () => notifier
          .reloadSaved()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: Loader<List<CommentNotifier>>(
        load: (_) => notifier.loadSaved(),
        data: (_) => notifier.savedComments,
        onData: (_, comments) {
          return ListView(
            shrinkWrap: true,
            children: [
              for (final comment in comments)
                ChangeNotifierProvider<CommentNotifier>.value(
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
