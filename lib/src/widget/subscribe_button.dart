import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/notifier/auth_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/collapse_mixin.dart';
import 'package:flutter_reddit_prototype/src/notifier/comment_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/current_user_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/home_front_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/home_popular_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/iterable_sum.dart';
import 'package:flutter_reddit_prototype/src/notifier/likable.dart';
import 'package:flutter_reddit_prototype/src/notifier/limit.dart';
import 'package:flutter_reddit_prototype/src/notifier/list_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/message_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/property_listener.dart';
import 'package:flutter_reddit_prototype/src/notifier/replyable.dart';
import 'package:flutter_reddit_prototype/src/notifier/reportable.dart';
import 'package:flutter_reddit_prototype/src/notifier/rule_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/savable.dart';
import 'package:flutter_reddit_prototype/src/notifier/score.dart';
import 'package:flutter_reddit_prototype/src/notifier/search_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/search_subreddits.dart';
import 'package:flutter_reddit_prototype/src/notifier/submission_loader_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/submission_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/submissions_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/subreddit_loader_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/subreddit_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/try_mixin.dart';
import 'package:flutter_reddit_prototype/src/notifier/user_loader_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/user_notifier.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:flutter_reddit_prototype/src/widget/snackbar.dart';
import 'package:provider/provider.dart';

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifier>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: selectedColor),
      onPressed: () {
        (notifier.subreddit.userIsSubscriber
                ? notifier.unsubscribe()
                : notifier.subscribe())
            .catchError((e) => showErrorSnackBar(context, e));
      },
      child: Text(
        notifier.subreddit.userIsSubscriber
            ? (notifier.isUserSubreddit ? 'FOLLOWING' : 'JOINED')
            : (notifier.isUserSubreddit ? 'FOLLOW' : '+JOIN'),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
