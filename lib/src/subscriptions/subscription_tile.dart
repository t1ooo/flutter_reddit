import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:flutter_reddit_prototype/src/subreddit/subreddit_icon.dart';
import 'package:flutter_reddit_prototype/src/widget/snackbar.dart';

import 'package:provider/provider.dart';

import '../notifier/auth_notifier.dart';
import '../notifier/collapse_mixin.dart';
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
