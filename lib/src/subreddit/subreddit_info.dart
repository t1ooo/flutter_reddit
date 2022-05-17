import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../style/style.dart';
import '../widget/subscribe_button.dart';
import 'subreddit_icon.dart';

class SubredditInfo extends StatelessWidget {
  const SubredditInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifier>();
    final subreddit = notifier.subreddit;

    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(height: 100),
                SubredditIcon(icon: subreddit.communityIcon),
                SizedBox(width: 10),
                Text(subreddit.displayNamePrefixed, textScaleFactor: 2),
                Spacer(),
                SubscribeButton(),
              ],
            ),
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
