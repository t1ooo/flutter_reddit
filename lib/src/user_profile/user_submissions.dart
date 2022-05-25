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
import '../notifier/const.dart';
import '../notifier/list_notifier.dart';
import '../notifier/message_notifier.dart';
import '../notifier/property_listener.dart';
import '../notifier/replyable.dart';
import '../notifier/reportable.dart';
import '../notifier/rule_notifier.dart';
import '../notifier/savable.dart';
import '../notifier/score.dart';
import '../notifier/search_notifier.dart';
import '../notifier/search_subreddits_notifier.dart';
import '../notifier/submission_loader_notifier.dart';
import '../notifier/submission_notifier.dart';
import '../notifier/submissions_notifier.dart';
import '../notifier/subreddit_loader_notifier.dart';
import '../notifier/subreddit_notifier.dart';
import '../notifier/try_mixin.dart';
import '../notifier/user_loader_notifier.dart';
import '../notifier/user_notifier.dart';

import '../widget/list.dart';
import '../widget/snackbar.dart';
import '../widget/loader.dart';

class UserSubmissions extends StatelessWidget {
  const UserSubmissions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserNotifier>();

    return SwipeToRefresh(
      onRefresh: () => notifier
          .reloadSubmissions()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: Loader<List<SubmissionNotifier>>(
        load: (_) => notifier.loadSubmissions(),
        data: (_) => notifier.submissions,
        onData: (_, submissions) {
          return CustomListView(
            shrinkWrap: true,
            children: [
              for (final sub in submissions)
                ChangeNotifierProvider<SubmissionNotifier>.value(
                  value: sub,
                  child: SubmissionTile(),
                ),
            ],
          );
        },
      ),
    );
  }
}
