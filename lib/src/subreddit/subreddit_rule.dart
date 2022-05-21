import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/auth_notifier.dart';
import '../notifier/collapsible.dart';
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
import '../notifier/search_subreddits_notifier.dart';
import '../notifier/submission_loader_notifier.dart';
import '../notifier/submission_notifier.dart';
import '../notifier/submissions_notifier.dart';
import '../notifier/subreddit_loader_notifier.dart';
import '../notifier/subreddit_notifier.dart';
import '../notifier/try_mixin.dart';
import '../notifier/user_loader_notifier.dart';
import '../notifier/user_notifier.dart';


class SubredditRule extends StatelessWidget {
  SubredditRule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<RuleNotifier>();
    final rule = notifier.rule;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          hoverColor: Colors.white,
          minLeadingWidth: 0,
          contentPadding: EdgeInsets.zero,
          leading: Text('${rule.priority + 1}.'),
          title: Text(rule.shortName),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 10),
            child:
                Icon(notifier.expanded ? Icons.expand_less : Icons.expand_more),
          ),
          onTap: () {
            notifier.expanded ? notifier.collapse() : notifier.expand();
          },
        ),
        AnimatedCrossFade(
          firstChild: Container(height: 0.0),
          secondChild: Text(notifier.rule.description),
          crossFadeState: notifier.expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: kThemeAnimationDuration,
        )
      ],
    );
  }
}
