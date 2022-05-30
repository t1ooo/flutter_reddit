import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/subreddit_notifier.dart';
import '../style.dart';
import '../util/format_members.dart';
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
      color: primaryColor,
      child: Padding(
        padding: pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      SubredditIcon(icon: subreddit.communityIcon),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          subreddit.displayNamePrefixed,
                          textScaleFactor: 2,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                ),
                SubscribeButton(),
              ],
            ),
            SizedBox(height: 30),
            Text('${formatMembers(subreddit.subscribers)} members'),
            SizedBox(height: 20),
            Text(subreddit.publicDescription),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
