import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/subreddit/subreddit_icon.dart';

import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../subreddit/subreddit_screen.dart';
import '../util/snackbar.dart';
import '../widget/list.dart';
import '../widget/loader.dart';
import '../widget/network_image.dart';
import '../widget/swipe_to_refresh.dart';
import 'subscription_tile.dart';

class Subscriptions extends StatelessWidget {
  const Subscriptions({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    // final notifier = context.watch<UserAuth>().user!;
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
              // Loader<SubredditNotifier>(
              //   load: (_) =>
              //       context.read<SubredditLoaderNotifier>().loadSubreddit('all'),
              //   data: (_) => context.read<SubredditLoaderNotifier>().subreddit,
              //   onData: (_, subreddit) {
              //     return ChangeNotifierProvider<SubredditNotifier>.value(
              //       value: subreddit,
              //       child: SubscriptionTile(),
              //     );
              //   },
              // ),
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

    // return CustomListView(
    //   children: [
    //     Loader<List<SubredditNotifier>>(
    //       load: (_) => notifier.loadSubreddits(),
    //       data: (_) => notifier.favoriteSubreddits,
    //       onData: (_, subreddits) {
    //         return CustomListView(
    //           children: [
    //             ListTitle('favorited'),
    //             for (final subreddit in subreddits)
    //               ChangeNotifierProvider<SubredditNotifier>.value(
    //                 value: subreddit,
    //                 child: SubscriptionTile(),
    //               )
    //           ],
    //         );
    //       },
    //     ),
    //     Loader<List<SubredditNotifier>>(
    //       load: (_) => notifier.loadSubreddits(),
    //       data: (_) => notifier.unfavoriteSubreddits,
    //       onData: (_, subreddits) {
    //         return CustomListView(
    //           children: [
    //             ListTitle('unfavorited'),
    //             for (final subreddit in subreddits)
    //               ChangeNotifierProvider<SubredditNotifier>.value(
    //                 value: subreddit,
    //                 child: SubscriptionTile(),
    //               )
    //           ],
    //         );
    //       },
    //     ),
    //   ],
    // );

/* 
    // TODO: Loader
    final notifier = context.watch<CurrentUserNotifier>();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      notifier.loadSubreddits();
    });
    final subreddits = notifier.subreddits;
    if (subreddits == null) {
      return Center(child: CircularProgressIndicator());
    }

    // TODO: move to Subscription widget
    return ListView(
      shrinkWrap: true,
      children: [
        for (final subreddit in subreddits)
          ListTile(
            leading: SizedBox(
              width: 16,
              height: 16,
              child: (subreddit.subreddit.communityIcon != '')
                  // ? Image.network(subreddit.subreddit.communityIcon)
                  ? CustomNetworkImageBuilder(subreddit.subreddit.communityIcon)
                  : Image.asset('communityIcon.png'),
            ),
            title: Text(subreddit.subreddit.displayNamePrefixed),
            trailing: Icon(Icons.star),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ChangeNotifierProvider<SubredditNotifier>.value(
                    value: subreddit,
                    child: SubredditScreen(),
                  ),
                ),
              );
            },
          )
      ],
    ); */
  }
}
