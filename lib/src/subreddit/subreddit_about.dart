import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../const.dart';
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
import '../style.dart';
import '../widget/list.dart';
import '../widget/loader.dart';
import '../widget/markdown.dart';
import 'subreddit_rule.dart';

class SubredditAbout extends StatelessWidget {
  const SubredditAbout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<SubredditNotifier>();
    final subreddit = notifier.subreddit;
    final titleStyle = TextStyle(fontWeight: FontWeight.bold);

    print(subreddit.description);
    print('-------------------');
    return CustomListView(
      shrinkWrap: true,
      children: [
        SizedBox(height: 10),
        if (subreddit.description != '') ...[
          Card(
            child: Padding(
              padding: cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About', style: titleStyle),
                  Divider(height: 30),
                  Markdown(subreddit.description, baseUrl: redditBaseUrl),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
        Loader<List<RuleNotifier>>(
          load: (_) => notifier.loadRules(),
          data: (_) => notifier.rules,
          onData: (_, rules) {
            if (rules == []) return Container();
            return Card(
              child: Padding(
                padding: cardPadding,
                child: CustomListView(
                  shrinkWrap: true,
                  children: [
                    Text('Rules', style: titleStyle),
                    Divider(height: 30),
                    for (final rule in rules) ...[
                      ChangeNotifierProvider<RuleNotifier>.value(
                        value: rule,
                        child: SubredditRule(),
                      ),
                      Divider(height: 30),
                    ]
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
