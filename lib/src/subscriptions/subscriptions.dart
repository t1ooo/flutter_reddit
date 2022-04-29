import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../subreddit/subreddit_screen.dart';
import '../widget/network_image.dart';

class Subscriptions extends StatelessWidget {
  const Subscriptions({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    // TODO: Loader
    final notifier = context.watch<CurrentUserNotifierQ>();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      notifier.loadSubreddits();
    });
    final subreddits = notifier.subreddits;
    if (subreddits == null) {
      return Center(child: CircularProgressIndicator());
    }

    // TODO: move to Subscription widget
    return ListView(
      shrinkWrap: true,
      children: [
        for (final subreddit in subreddits)
          ListTile(
            leading: SizedBox(
              width: 16,
              height: 16,
              child: (subreddit.subreddit.communityIcon != '')
                  // ? Image.network(subreddit.subreddit.communityIcon)
                  ? CustomNetworkImageBuilder(subreddit.subreddit.communityIcon)
                  : Image.asset('communityIcon.png'),
            ),
            title: Text(subreddit.subreddit.displayNamePrefixed),
            trailing: Icon(Icons.star),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ChangeNotifierProvider<SubredditNotifierQ>.value(
                    value: subreddit,
                    child: SubredditScreen(),
                  ),
                ),
              );
            },
          )
      ],
    );
  }
}
