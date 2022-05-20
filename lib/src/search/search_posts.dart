import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/widget/swipe_to_refresh.dart';
import 'package:provider/provider.dart';

import '../submission_tile/submission_tiles.dart';
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
import '../reddit_api/reddit_api.dart';
import '../widget/snackbar.dart';

class SearchPosts extends StatelessWidget {
  const SearchPosts({
    Key? key,
    required this.query,
    this.subreddit,
  }) : super(key: key);

  final String query;
  final String? subreddit;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SearchNotifier>();

    return SwipeToRefresh(
      onRefresh: () => notifier
          .reloadSearch()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: SubmissionTiles<Sort>(
        type: notifier.sort,
        types: Sort.values,
        submissions: notifier.submissions,
        load: (subType) => subreddit != null
            ? notifier.search(query, subType, subreddit!)
            : notifier.search(query, subType),
      ),
    );
  }
}
