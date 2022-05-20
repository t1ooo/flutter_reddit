import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/login/login_screen.dart';
import 'package:flutter_reddit_prototype/src/widget/custom_future_builder.dart';
import 'package:provider/provider.dart';

import 'notifier/auth_notifier.dart';
import 'notifier/collapse_mixin.dart';
import 'notifier/comment_notifier.dart';
import 'notifier/current_user_notifier.dart';
import 'notifier/home_front_notifier.dart';
import 'notifier/home_popular_notifier.dart';
import 'notifier/iterable_sum.dart';
import 'notifier/likable.dart';
import 'notifier/limit.dart';
import 'notifier/list_notifier.dart';
import 'notifier/message_notifier.dart';
import 'notifier/property_listener.dart';
import 'notifier/replyable.dart';
import 'notifier/reportable.dart';
import 'notifier/rule_notifier.dart';
import 'notifier/savable.dart';
import 'notifier/score.dart';
import 'notifier/search_notifier.dart';
import 'notifier/search_subreddits.dart';
import 'notifier/submission_loader_notifier.dart';
import 'notifier/submission_notifier.dart';
import 'notifier/submissions_notifier.dart';
import 'notifier/subreddit_loader_notifier.dart';
import 'notifier/subreddit_notifier.dart';
import 'notifier/try_mixin.dart';
import 'notifier/user_loader_notifier.dart';
import 'notifier/user_notifier.dart';
import 'tabs.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final notifier = context.watch<AuthNotifier>();
        return CustomFutureBuilder<bool>(
          future: notifier.loginSilently(),
          onData: (_, ok) {
            if (ok) {
              return Tabs();
            }
            return LoginScreen();
          },
          onError: (_, e) {
            print('$e');
            return LoginScreen();
          },
        );
      },
    );
  }
}
