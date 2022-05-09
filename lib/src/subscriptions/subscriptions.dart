import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/subreddit/subreddit_icon.dart';

import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../subreddit/subreddit_screen.dart';
import '../widget/list.dart';
import '../widget/loader.dart';
import '../widget/network_image.dart';
import 'subscription_tile.dart';

class Subscriptions extends StatelessWidget {
  const Subscriptions({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    // final notifier = context.watch<UserAuth>().user!;
    final notifier = context.watch<CurrentUserNotifierQ>();

    return Loader<List<SubredditNotifierQ>>(
      load: (_) => notifier.loadSubreddits(),
      data: (_) => notifier.subreddits,
      onData: (_, subreddits) {
        final favoriteSubreddits =
            CurrentUserNotifierQ.filterFavorite(subreddits);
        final unfavoriteSubreddits =
            CurrentUserNotifierQ.filterUnfavorite(subreddits);

        return CustomListView(
          children: [
            // Loader<SubredditNotifierQ>(
            //   load: (_) =>
            //       context.read<SubredditLoaderNotifierQ>().loadSubreddit('all'),
            //   data: (_) => context.read<SubredditLoaderNotifierQ>().subreddit,
            //   onData: (_, subreddit) {
            //     return ChangeNotifierProvider<SubredditNotifierQ>.value(
            //       value: subreddit,
            //       child: SubscriptionTile(),
            //     );
            //   },
            // ),
            ChangeNotifierProvider<SubredditNotifierQ>.value(
              value: notifier.all!,
              child: SubscriptionTile(favorite: false),
            ),
            if (favoriteSubreddits.isNotEmpty) ...[
              ListTitle('favorited'),
              for (final subreddit in favoriteSubreddits)
                ChangeNotifierProvider<SubredditNotifierQ>.value(
                  value: subreddit,
                  child: SubscriptionTile(),
                ),
            ],
            if (unfavoriteSubreddits.isNotEmpty) ...[
              ListTitle('communites'),
              for (final subreddit in unfavoriteSubreddits)
                ChangeNotifierProvider<SubredditNotifierQ>.value(
                  value: subreddit,
                  child: SubscriptionTile(),
                ),
            ]
          ],
        );
      },
    );

    // return CustomListView(
    //   children: [
    //     Loader<List<SubredditNotifierQ>>(
    //       load: (_) => notifier.loadSubreddits(),
    //       data: (_) => notifier.favoriteSubreddits,
    //       onData: (_, subreddits) {
    //         return CustomListView(
    //           children: [
    //             ListTitle('favorited'),
    //             for (final subreddit in subreddits)
    //               ChangeNotifierProvider<SubredditNotifierQ>.value(
    //                 value: subreddit,
    //                 child: SubscriptionTile(),
    //               )
    //           ],
    //         );
    //       },
    //     ),
    //     Loader<List<SubredditNotifierQ>>(
    //       load: (_) => notifier.loadSubreddits(),
    //       data: (_) => notifier.unfavoriteSubreddits,
    //       onData: (_, subreddits) {
    //         return CustomListView(
    //           children: [
    //             ListTitle('unfavorited'),
    //             for (final subreddit in subreddits)
    //               ChangeNotifierProvider<SubredditNotifierQ>.value(
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
    final notifier = context.watch<CurrentUserNotifierQ>();
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
                      ChangeNotifierProvider<SubredditNotifierQ>.value(
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
