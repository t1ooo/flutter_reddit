
import 'package:flutter/material.dart';
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
import '../notifier/savable_mixin.dart';
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
import '../widget/swipe_to_refresh.dart';
import 'search_subreddit.dart';

class SearchSubreddits extends StatelessWidget {
  const SearchSubreddits({
    Key? key,
    required this.query,
  }) : super(key: key);

  final String query;

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<SearchSubredditsQ>();

    return SwipeToRefresh(
      onRefresh: () => notifier
          .reloadSearch()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: Loader<List<SubredditNotifier>>(
        load: (_) => notifier.search(query),
        data: (_) => notifier.subreddits,
        onData: (_, subreddits) {
          return Container(
            color: Theme.of(context).primaryColor,
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final subreddit in subreddits)
                  ChangeNotifierProvider<SubredditNotifier>.value(
                    value: subreddit,
                    child: SearchSubreddit(),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

 
 
 
 
 
 
 
 
 
 

 
 
 
 
 
 
 
 
 
 
}
