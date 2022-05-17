import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:flutter_reddit_prototype/src/subreddit/subreddit_icon.dart';
import 'package:flutter_reddit_prototype/src/util/snackbar.dart';

import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../subreddit/subreddit_screen.dart';

class SubscriptionTile extends StatelessWidget {
  const SubscriptionTile({Key? key, this.favorite = true}) : super(key: key);

  final bool favorite;

  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifier>();
    final subreddit = notifier.subreddit;

    return ListTile(
      leading: SizedBox.square(
        dimension: 40,
        child: SubredditIcon(icon: subreddit.communityIcon),
      ),
      title: Text(subreddit.displayNamePrefixed),
      trailing: favorite
          ? IconButton(
              onPressed: () {
                (subreddit.userHasFavorited
                        ? notifier.unfavorite()
                        : notifier.favorite())
                    .catchError((e) => showErrorSnackBar(context, e));
              },
              icon: Icon(Icons.star,
                  color: subreddit.userHasFavorited ? selectedColor : null),
            )
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<SubredditNotifier>.value(
              value: notifier,
              child: SubredditScreen(),
            ),
          ),
        );
      },
    );
  }
}
