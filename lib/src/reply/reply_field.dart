import 'package:flutter/material.dart';

import 'reply_screen.dart';
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
import '../style/style.dart';

class ReplyField extends StatelessWidget {
  const ReplyField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: pagePadding.copyWith(top: 10, bottom: 10),
        child: TextField(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    InheritedProvider<Replyable>.value(
                  value: context.read<SubmissionNotifier>(),
                  child: ReplyScreen(),
                ),
              ),
            );
          },
          decoration: InputDecoration(
            hintText: 'Add a comment',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
