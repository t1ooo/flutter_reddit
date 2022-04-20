import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/util/snackbar.dart';
import 'package:provider/provider.dart';

import '../home/submission_tiles.v2.dart';
import '../notifier/reddir_notifier.dart';
import '../provider.dart';
import '../reddit_api/reddir_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/subreddit.dart';
import '../search/search_field.dart';
import '../style/style.dart';
import '../widget/future_elevated_button.dart';
import '../widget/sized_placeholder.dart';
import '../widget/stream_list_builder.dart';

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({
    Key? key,
    required this.subreddit,
    // required this.isSubscriber,
    this.isUserPage = false,
  }) : super(key: key);

  final Subreddit subreddit;
  // final bool isSubscriber;
  final bool isUserPage;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [subscriptionNotifierProvider(subreddit.userIsSubscriber)],
      child: Builder(
        builder: (c) {
          final sn = c.watch<SubscriptionNotifier>();
          // final error = sn.error;
          // if (error != null) {
          //   // TODO: handle error
          // }
          if (sn.isSubscriber)
            return FutureElevatedButton(
              onPressed: () async {
                final result = await sn.unsubscribe(subreddit.name);
                if (result != null) {
                  showSnackBar(context, result);
                }
              },
              child: Text(isUserPage ? 'FOLLOWING' : 'LEAVE'),
            );
          else
            return FutureElevatedButton(
              onPressed: () async {
                final result = await sn.subscribe(subreddit.name);
                if (result != null) {
                  showSnackBar(context, result);
                }
              },
              child: Text(isUserPage ? 'FOLLOW' : '+JOIN'),
            );
        },
      ),
    );
  }
}
