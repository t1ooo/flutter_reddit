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
import '../style.dart';
import '../widget/subscribe_button.dart';
import 'subreddit_icon.dart';

class SubredditInfo extends StatelessWidget {
  const SubredditInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<SubredditNotifier>();
    final subreddit = notifier.subreddit;

    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SizedBox(height: 100),
                Flexible(
                  child: Row(
                    children: [
                      SubredditIcon(icon: subreddit.communityIcon),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          subreddit.displayNamePrefixed,
                          textScaleFactor: 2,
                          // overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                ),
                // Spacer(),
                SubscribeButton(),
              ],
            ),
            SizedBox(height: 30),
            Text('${subreddit.subscribers} members'),
            SizedBox(height: 20),
            Text(subreddit.publicDescription),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
