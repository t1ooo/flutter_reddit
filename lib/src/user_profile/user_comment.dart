import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/submission/submission_screen.dart';
import 'package:provider/provider.dart';

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
import '../util/date_time.dart';

class UserComment extends StatelessWidget {
  const UserComment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<CommentNotifier>();
    final comment = notifier.comment;

    return Container(
      color: Theme.of(context).primaryColor,
      child: InkWell(
        onTap: comment.submissionId == ''
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubmissionScreen(id: comment.submissionId),
                  ),
                );
              },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.linkTitle,
                textScaleFactor: 1.7,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(comment.subredditNamePrefixed),
                  Text(' • '),
                  Text(formatDateTime(comment.created)),
                ],
              ),
              SizedBox(height: 10),
              Text(comment.body),
              Text(comment.isSubmitter.toString()),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
