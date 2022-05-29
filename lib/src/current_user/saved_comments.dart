import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/comment_notifier.dart';
import '../notifier/user_notifier.dart';
import '../widget/list.dart';
import '../widget/loader.dart';
import '../widget/pull_to_refresh.dart';
import '../widget/snackbar.dart';
import 'saved_comment.dart';

class SavedComments extends StatelessWidget {
  const SavedComments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserNotifier>();

    return PullToRefresh(
      onRefresh: () => notifier
          .reloadSaved()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: Loader<List<CommentNotifier>>(
        load: (_) => notifier.loadSaved(),
        data: (_) => notifier.savedComments,
        onData: (_, comments) {
          return CustomListView(
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
