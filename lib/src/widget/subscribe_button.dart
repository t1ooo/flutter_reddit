import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/notifier/reddir_notifier.v4_2.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:flutter_reddit_prototype/src/widget/snackbar.dart';
import 'package:provider/provider.dart';

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifier>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: selectedColor),
      onPressed: () {
        (notifier.subreddit.userIsSubscriber
                ? notifier.unsubscribe()
                : notifier.subscribe())
            .catchError((e) => showErrorSnackBar(context, e));
      },
      child: Text(
        notifier.subreddit.userIsSubscriber
            ? (notifier.isUserSubreddit ? 'FOLLOWING' : 'JOINED')
            : (notifier.isUserSubreddit ? 'FOLLOW' : '+JOIN'),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
