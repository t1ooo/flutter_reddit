import 'package:flutter/material.dart';

import '../notifier/auth_notifier.dart';
import '../notifier/collapsible.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/current_user_notifier.dart';
import '../notifier/home_front_notifier.dart';
import '../notifier/home_popular_notifier.dart';
import '../notifier/iterable_sum.dart';
import '../notifier/likable.dart';
import '../notifier/const.dart';
import '../notifier/list_notifier.dart';
import '../notifier/message_notifier.dart';
import '../notifier/property_listener.dart';
import '../notifier/replyable.dart';
import '../notifier/reportable.dart';
import '../notifier/rule_notifier.dart';
import '../notifier/savable.dart';
import '../notifier/score.dart';
import '../notifier/search_notifier.dart';
import '../notifier/search_subreddits_notifier.dart';
import '../notifier/submission_loader_notifier.dart';
import '../notifier/submission_notifier.dart';
import '../notifier/submissions_notifier.dart';
import '../notifier/subreddit_loader_notifier.dart';
import '../notifier/subreddit_notifier.dart';
import '../notifier/try_mixin.dart';
import '../notifier/user_loader_notifier.dart';
import '../notifier/user_notifier.dart';
import '../reddit_api/like.dart';
import 'snackbar.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({
    Key? key,
    required this.likable,
  }) : super(key: key);

  final Likable likable;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            likable.like().catchError((e) => showErrorSnackBar(context, e));
          },
          icon: Icon(
            Icons.expand_less,
            color: likable.likes == Like.up ? Colors.green : null,
          ),
        ),
        Text(_formatScore(likable.score)),
        // TODO: disable on progress
        IconButton(
          onPressed: () {
            likable.dislike().catchError((e) => showErrorSnackBar(context, e));
          },
          icon: Icon(
            Icons.expand_more,
            color: likable.likes == Like.down ? Colors.red : null,
          ),
        ),
      ],
    );
  }

  String _formatScore(int score) {
    if (score < 1000) {
      return score.toString();
    }
    return ((score * 10 / 1000).ceil() / 10).toString() + 'k';
  }
}
