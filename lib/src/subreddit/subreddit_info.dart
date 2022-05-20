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
