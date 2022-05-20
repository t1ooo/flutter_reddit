import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/widget/snackbar.dart';
import 'package:flutter_reddit_prototype/src/widget/swipe_to_refresh.dart';
import 'package:provider/provider.dart';

import '../notifier/auth_notifier.dart';
import '../notifier/collapse_mixin.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/current_user_notifier.dart';
import '../notifier/home_front_notifier.dart';
import '../notifier/home_popular_notifier.dart';
import '../notifier/iterable_sum.dart';
import '../notifier/likable_mixin.dart';
import '../notifier/limit.dart';
import '../notifier/list_notifier.dart';
import '../notifier/message_notifier.dart';
import '../notifier/property_listener.dart';
import '../notifier/replyable.dart';
import '../notifier/reportable.dart';
import '../notifier/rule_notifier.dart';
import '../notifier/savable.dart';
import '../notifier/score.dart';
import '../notifier/search_notifier.dart';
import '../notifier/search_subreddits.dart';
import '../notifier/submission_loader_notifier.dart';
import '../notifier/submission_notifier.dart';
import '../notifier/submissions_notifier.dart';
import '../notifier/subreddit_loader_notifier.dart';
import '../notifier/subreddit_notifier.dart';
import '../notifier/try_mixin.dart';
import '../notifier/user_loader_notifier.dart';
import '../notifier/user_notifier.dart';
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
