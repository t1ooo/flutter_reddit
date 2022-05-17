import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
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
