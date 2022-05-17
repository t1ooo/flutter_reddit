import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../util/snackbar.dart';
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
          final favoriteSubreddits =
              CurrentUserNotifier.filterFavorite(subreddits);
          final unfavoriteSubreddits =
              CurrentUserNotifier.filterUnfavorite(subreddits);

          return CustomListView(
            children: [
              ChangeNotifierProvider<SubredditNotifier>.value(
                value: notifier.all!,
                child: SubscriptionTile(favorite: false),
              ),
              if (favoriteSubreddits.isNotEmpty) ...[
                ListTitle('favorited'),
                for (final subreddit in favoriteSubreddits)
                  ChangeNotifierProvider<SubredditNotifier>.value(
                    value: subreddit,
                    child: SubscriptionTile(),
                  ),
              ],
              if (unfavoriteSubreddits.isNotEmpty) ...[
                ListTitle('communites'),
                for (final subreddit in unfavoriteSubreddits)
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
