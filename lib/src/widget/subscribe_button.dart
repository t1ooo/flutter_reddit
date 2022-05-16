import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/notifier/reddir_notifier.v4_2.dart';
import 'package:flutter_reddit_prototype/src/util/snackbar.dart';
import 'package:provider/provider.dart';

import '../widget/future_elevated_button.dart';

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({
    Key? key,
    // this.isUserPage = false,
  }) : super(key: key);

  // final bool isUserPage;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifier>();
    return FutureElevatedButton(
      onPressed: () {
        return (notifier.subreddit.userIsSubscriber
                ? notifier.unsubscribe()
                : notifier.subscribe())
            .catchError((e) => showErrorSnackBar(context, e));
      },
      child: Text(notifier.subreddit.userIsSubscriber
          ? (notifier.isUserSubreddit ? 'FOLLOWING' : 'JOINED')
          : (notifier.isUserSubreddit ? 'FOLLOW' : '+JOIN')),
    );

    /* if (notifier.subreddit.userIsSubscriber)
      return FutureElevatedButton(
        onPressed: () {
          return notifier
              .unsubscribe()
              .catchError((e) => showErrorSnackBar(context, e));
        },
        child: Text(notifier.isUserSubreddit ? 'FOLLOWING' : 'JOINED'),
      );
    else
      return FutureElevatedButton(
        onPressed: () {
          return notifier
              .subscribe()
              .catchError((e) => showErrorSnackBar(context, e));
        },
        child: Text(notifier.isUserSubreddit ? 'FOLLOW' : '+JOIN'),
      ); */
  }
}
