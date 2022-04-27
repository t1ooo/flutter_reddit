import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/notifier/reddir_notifier.v4_2.dart';
import 'package:flutter_reddit_prototype/src/util/snackbar.dart';
import 'package:provider/provider.dart';

// import '../home/submission_tiles.v2.dart';
// import '../notifier/reddir_notifier.dart';
// import '../provider.dart';
import '../reddit_api/reddir_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/subreddit.dart';
import '../search/search_field.dart';
import '../style/style.dart';
import '../widget/future_elevated_button.dart';
import '../widget/sized_placeholder.dart';
// import '../widget/stream_list_builder.dart';

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({
    Key? key,
    // required this.subreddit,
    // required this.isSubscriber,
    this.isUserPage = false,
  }) : super(key: key);

  // final Subreddit subreddit;
  // final bool isSubscriber;
  final bool isUserPage;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifierQ>();
    if (notifier.subreddit.userIsSubscriber)
      return FutureElevatedButton(
        onPressed: () {
          return notifier
              .unsubscribe()
              .catchError((e) => showSnackBar(context, e));
        },
        child: Text(isUserPage ? 'FOLLOWING' : 'LEAVE'),
      );
    else
      return FutureElevatedButton(
        onPressed: () {
          return notifier
              .subscribe()
              .catchError((e) => showSnackBar(context, e));
        },
        child: Text(isUserPage ? 'FOLLOW' : '+JOIN'),
      );
  }
}
