import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import '../reddit_api/subreddit.dart';
import '../subreddit/subreddit_screen.dart';
import '../widget/stream_list_builder.dart';

class Subscriptions extends StatelessWidget {
  const Subscriptions({
    Key? key,
    // this.subreddits,
  }) : super(key: key);

  // final List<Subreddit>? subreddits;

  // @override
  // Widget build(BuildContext context) {
  //   final notifier = context.read<RedditNotifier>();
  //   return ListView(shrinkWrap: true, children: [
  //     for (final subreddit in notifier.userSubreddits ?? [])
  //       // Text(subreddit.displayName)
  //       ListTile(
  //         leading: SizedBox(
  //           width: 16,
  //           height: 16,
  //           child: (subreddit.communityIcon != '')
  //               ? Image.network(subreddit.communityIcon)
  //               : Image.asset('communityIcon.png'),
  //         ),
  //         title: Text(subreddit.displayNamePrefixed),
  //         trailing: Icon(Icons.star),
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (_) => SubredditScreen(subreddit: subreddit),
  //             ),
  //           );
  //         },
  //       ),
  //   ]);
  // }
  Widget build(BuildContext context) {
    // return CustomStreamBuilder(
    //   stream: context.read<RedditNotifier>().userSubreddits(),
    //   onData: (context, Subreddit subreddit) {
    //     return ListTile(
    //       leading: SizedBox(
    //         width: 16,
    //         height: 16,
    //         child: (subreddit.communityIcon != '')
    //             ? Image.network(subreddit.communityIcon)
    //             : Image.asset('communityIcon.png'),
    //       ),
    //       title: Text(subreddit.displayNamePrefixed),
    //       trailing: Icon(Icons.star),
    //       onTap: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (_) => SubredditScreen(subreddit: subreddit),
    //           ),
    //         );
    //       },
    //     );
    //   },
    // );

    return StreamListBuilder(
      stream: context.read<CurrentUserNotifier>().subreddits(),
      onData: (context, List<Subreddit> subreddits) {
        subreddits.sort((a, b) => a.displayName.compareTo(b.displayName));

        // TODO: move to Subscription widget
        return ListView(
          shrinkWrap: true,
          children: [
            for (final subreddit in subreddits)
              ListTile(
                leading: SizedBox(
                  width: 16,
                  height: 16,
                  child: (subreddit.communityIcon != '')
                      ? Image.network(subreddit.communityIcon)
                      : Image.asset('communityIcon.png'),
                ),
                title: Text(subreddit.displayNamePrefixed),
                trailing: Icon(Icons.star),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubredditScreen(subreddit: subreddit),
                    ),
                  );
                },
              )
          ],
        );
      },
    );
  }
}
