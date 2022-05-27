import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/current_user_notifier.dart';
import '../notifier/subreddit_notifier.dart';
import '../widget/list.dart';
import '../widget/loader.dart';
import '../widget/snackbar.dart';
import '../widget/swipe_to_refresh.dart';
import 'subscription_tile.dart';

class Subscriptions extends StatelessWidget {
  const Subscriptions({
    Key? key,
  }) : super(key: key);

  @override
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
          final favorite = _filterFavorite(subreddits);
          final unfavorite = _filterUnfavorite(subreddits);

          return PrimaryColorListView(
            children: [
              SubscriptionAllTile(),
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

  List<SubredditNotifier> _filterFavorite(List<SubredditNotifier> subreddits) =>
      subreddits.where((v) => v.subreddit.userHasFavorited).toList();

  List<SubredditNotifier> _filterUnfavorite(
          List<SubredditNotifier> subreddits) =>
      subreddits.where((v) => !v.subreddit.userHasFavorited).toList();
}
