import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/widget/swipe_to_refresh.dart';
import 'package:provider/provider.dart';

import '../submission_tile/submission_tile.dart';
import '../notifier/auth_notifier.dart';
import '../notifier/collapsible.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/current_user_notifier.dart';
import '../notifier/home_front_notifier.dart';
import '../notifier/home_popular_notifier.dart';
import '../notifier/iterable_sum.dart';
import '../notifier/likable.dart';
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
import '../widget/snackbar.dart';
import '../widget/loader.dart';
import 'submission_comment.dart';

class SubmissionWidget extends StatelessWidget {
  SubmissionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubmissionNotifier>();

    return SwipeToRefresh(
      onRefresh: () => notifier
          .reloadSubmission()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: ListView(
        children: [
          SubmissionTile(fullpage: true),
          SizedBox(height: 50),
          Loader<List<CommentNotifier>>(
            load: (_) => notifier.loadComments(),
            data: (_) => notifier.comments,
            onData: (_, comments) {
              return ListView(
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
