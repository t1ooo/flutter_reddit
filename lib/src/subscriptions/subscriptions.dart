import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

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
import '../widget/list.dart';
import '../widget/loader.dart';
import '../widget/swipe_to_refresh.dart';
import 'subscription_tile.dart';

class Subscriptions extends StatelessWidget {
  const Subscriptions({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    final notifier = context.watch<CurrentUserNotifier>();

    return SwipeToRefresh(
      onRefresh: () => notifier
          .reloadSubreddits()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: Loader<List<SubredditNotifier>>(
        load: (_) => notifier.loadSubreddits(),
        data: (_) => notifier.subreddits,
        onData: (_, subreddits) {
          final favorite =
              CurrentUserNotifier.filterFavorite(subreddits);
          final unfavorite =
              CurrentUserNotifier.filterUnfavorite(subreddits);

          return CustomListView(
            children: [
              ChangeNotifierProvider<SubredditNotifier>.value(
                value: notifier.all!,
                child: SubscriptionTile(favorite: false),
              ),
              if (favorite.isNotEmpty) ...[
                ListTitle('favorited'),
                for (final subreddit in favorite)
                  ChangeNotifierProvider<SubredditNotifier>.value(
                    value: subreddit,
                    child: SubscriptionTile(),
                  ),
              ],
              if (unfavorite.isNotEmpty) ...[
                ListTitle('communites'),
                for (final subreddit in unfavorite)
                  ChangeNotifierProvider<SubredditNotifier>.value(
                    value: subreddit,
                    child: SubscriptionTile(),
                  ),
              ]
            ],
          );
        },
      ),
    );
  }
}
