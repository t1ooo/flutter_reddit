import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/widget/snackbar.dart';
import 'package:provider/provider.dart';

import '../style/style.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../subreddit/subreddit_icon.dart';

class SearchSubreddit extends StatelessWidget {
  const SearchSubreddit({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    final subredditN = context.watch<SubredditNotifier>();
    final subreddit = subredditN.subreddit;

    return ListTile(
      leading: SizedBox.square(
        dimension: 40,
        child: SubredditIcon(icon: subreddit.communityIcon),
      ),
      title: Text(subredditN.name),
      subtitle: Text('${subreddit.subscribers} members'),
      trailing: IconButton(
        onPressed: () {
          (subreddit.userIsSubscriber
                  ? subredditN.unsubscribe()
                  : subredditN.subscribe())
              .catchError((e) => showErrorSnackBar(context, e));
        },
        icon: Icon(
          subreddit.userIsSubscriber ? Icons.check_box : Icons.add_box,
          color: selectedColor,
        ),
      ),
    );
  }
}
