import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/user_profile/user_comment.dart';
import 'package:flutter_reddit_prototype/src/widget/swipe_to_refresh.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../widget/snackbar.dart';
import '../widget/loader.dart';

class UserComments extends StatelessWidget {
  const UserComments({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserNotifier>();

    return SwipeToRefresh(
      onRefresh: () => notifier
          .reloadComments()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: Loader<List<CommentNotifier>>(
        load: (_) => notifier.loadComments(),
        data: (_) => notifier.comments,
        onData: (_, comments) {
          return ListView(
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
