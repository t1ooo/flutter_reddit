
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/style.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../subreddit/subreddit_icon.dart';

class SearchSubreddit extends StatelessWidget {
  const SearchSubreddit({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    final subredditN = context.watch<SubredditNotifierQ>();
    final subreddit = subredditN.subreddit;

    return ListTile(
      leading: SizedBox.square(
        dimension: 40,
        child: SubredditIcon(icon: subreddit.communityIcon),
      ),
      title: Text(subredditN.name),
      subtitle: Text('${subreddit.subscribers} members'),
      trailing: subreddit.userIsSubscriber
          ? IconButton(
              onPressed: () {
                subredditN.unsubscribe();
              },
              icon: Icon(Icons.check_box, color: selectedColor),
            )
          : IconButton(
              onPressed: () {
                subredditN.subscribe();
              },
              icon: Icon(Icons.add_box, color: selectedColor),
            ),
    );
  }
}
