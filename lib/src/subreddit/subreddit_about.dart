import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../const.dart';
import '../notifier/rule_notifier.dart';
import '../notifier/subreddit_notifier.dart';
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

    return CustomListView(
      key: PageStorageKey(runtimeType.toString()),
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
