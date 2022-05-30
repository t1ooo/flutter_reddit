import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/comment_notifier.dart';
import '../notifier/user_notifier.dart';
import '../widget/list.dart';
import '../widget/loader.dart';
import '../widget/pull_to_refresh.dart';
import '../widget/snackbar.dart';
import 'user_comment.dart';

class UserComments extends StatelessWidget {
  const UserComments({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<UserNotifier>();

    return PullToRefresh(
      onRefresh: () => notifier
          .reloadComments()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: Loader<List<CommentNotifier>>(
        load: (_) => notifier.loadComments(),
        data: (_) => notifier.comments,
        onData: (_, comments) {
          return CustomListView(
            key: PageStorageKey(runtimeType.toString()),
            children: [
              for (final comment in comments)
                ChangeNotifierProvider<CommentNotifier>.value(
                  value: comment,
                  child: UserComment(),
                ),
            ],
          );
        },
      ),
    );
  }
}
