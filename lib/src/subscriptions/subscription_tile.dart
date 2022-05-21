import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:flutter_reddit_prototype/src/subreddit/subreddit_icon.dart';
import 'package:flutter_reddit_prototype/src/widget/snackbar.dart';

import 'package:provider/provider.dart';

import '../notifier/subreddit_notifier.dart';
import '../subreddit/subreddit_all_screen.dart';
import '../subreddit/subreddit_screen.dart';

const _contentPadding = EdgeInsets.symmetric(horizontal:16, vertical: 5);

class SubscriptionTile extends StatelessWidget {
  const SubscriptionTile({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifier>();
    final subreddit = notifier.subreddit;

    return ListTile(
      contentPadding: _contentPadding,
      leading: SizedBox.square(
        dimension: 40,
        child: SubredditIcon(icon: subreddit.communityIcon),
      ),
      title: Text(subreddit.displayNamePrefixed),
      trailing: IconButton(
        onPressed: () {
          (subreddit.userHasFavorited
                  ? notifier.unfavorite()
                  : notifier.favorite())
              .catchError((e) => showErrorSnackBar(context, e));
        },
        icon: Icon(Icons.star,
            color: subreddit.userHasFavorited ? selectedColor : null),
      ),
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

class SubscriptionAllTile extends StatelessWidget {
  const SubscriptionAllTile({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: _contentPadding,
      leading: SizedBox.square(
        dimension: 40,
        child: SubredditIcon(icon: ''),
      ),
      title: Text('All'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SubredditAllScreen(),
          ),
        );
      },
    );
  }
}
