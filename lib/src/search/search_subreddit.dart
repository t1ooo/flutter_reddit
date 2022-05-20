import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/widget/snackbar.dart';
import 'package:provider/provider.dart';

import '../style/style.dart';
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
import '../subreddit/subreddit_icon.dart';

class SearchSubreddit extends StatelessWidget {
  const SearchSubreddit({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    final subredditN = context.watch<SubredditNotifier>();
    final subreddit = subredditN.subreddit;

    return ListTile(
      leading: SizedBox.square(
        dimension: 40,
        child: SubredditIcon(icon: subreddit.communityIcon),
      ),
      title: Text(subredditN.name),
      subtitle: Text('${subreddit.subscribers} members'),
      trailing: IconButton(
        onPressed: () {
          (subreddit.userIsSubscriber
                  ? subredditN.unsubscribe()
                  : subredditN.subscribe())
              .catchError((e) => showErrorSnackBar(context, e));
        },
        icon: Icon(
          subreddit.userIsSubscriber ? Icons.check_box : Icons.add_box,
          color: selectedColor,
        ),
      ),
    );
  }
}
