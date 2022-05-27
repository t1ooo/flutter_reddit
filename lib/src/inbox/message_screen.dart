import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/notifier/auth_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/collapsible.dart';
import 'package:flutter_reddit_prototype/src/notifier/comment_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/current_user_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/home_front_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/home_popular_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/iterable_sum.dart';
import 'package:flutter_reddit_prototype/src/notifier/likable.dart';
import 'package:flutter_reddit_prototype/src/notifier/const.dart';
import 'package:flutter_reddit_prototype/src/notifier/list_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/message_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/property_listener.dart';
import 'package:flutter_reddit_prototype/src/notifier/replyable.dart';
import 'package:flutter_reddit_prototype/src/notifier/reportable.dart';
import 'package:flutter_reddit_prototype/src/notifier/rule_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/savable.dart';
import 'package:flutter_reddit_prototype/src/notifier/score.dart';
import 'package:flutter_reddit_prototype/src/notifier/search_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/search_subreddits_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/submission_loader_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/submission_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/submissions_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/subreddit_loader_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/subreddit_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/try_mixin.dart';
import 'package:flutter_reddit_prototype/src/notifier/user_loader_notifier.dart';
import 'package:flutter_reddit_prototype/src/notifier/user_notifier.dart';
import 'package:flutter_reddit_prototype/src/style.dart';
import 'package:provider/provider.dart';

import '../const.dart';
import '../current_user/user_menu.dart';
import '../user_profile/user_profile_screen.dart';
import '../util/date_time.dart';
import '../widget/list.dart';
import '../widget/markdown.dart';
import '../widget/sliver_app_bar.dart';
import 'message.dart';

class MessageScreen extends StatelessWidget {
  MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserMenu(),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            PrimarySliverAppBar(
              collapsed: true,
              flexibleSpace: SpaceBar(
                leading: AppBarBackButton(),
                title: AppBarTitle('Inbox'),
              ),
            ),
          ];
        },
        body: MessageWidget(),
      ),
    );
  }
}
