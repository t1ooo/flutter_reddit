import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/subreddit_notifier.dart';
import '../style.dart';
import 'async_button_builder.dart';
import 'snackbar.dart';

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifier>();
    final subreddit = notifier.subreddit;

    return AsyncButtonBuilder(
      onPressed: () => notifier
          .subscribe(!subreddit.userIsSubscriber)
          .catchError((e) => showErrorSnackBar(context, e)),
      builder: (_, onPressed) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(primary: selectedColor),
          onPressed: onPressed,
          child: Text(
            subreddit.userIsSubscriber
                ? (notifier.isUserSubreddit ? 'FOLLOWING' : 'JOINED')
                : (notifier.isUserSubreddit ? 'FOLLOW' : '+JOIN'),
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}
