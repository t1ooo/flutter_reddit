import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';


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
