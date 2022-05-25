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
import 'package:flutter_reddit_prototype/src/user_profile/user_trophies.dart';
import 'package:flutter_reddit_prototype/src/widget/snackbar.dart';
import 'package:provider/provider.dart';

import '../util/date_time.dart';
import '../widget/list.dart';

class UserAbout extends StatelessWidget {
  const UserAbout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserNotifier>().user;
    return PrimaryColorListView(
      children: [
        ListDivider(height: 10),
        PrimaryColorListView(
          children: [
            SizedBox(height: 50),
            Table(
              children: [
                TableRow(
                  children: [
                    Center(child: Text(user.totalKarma.toString())),
                    Center(child: Text(formatDateTime(user.created))),
                  ],
                ),
                TableRow(
                  children: [
                    Center(child: Text('Karma')),
                    Center(child: Text('Reddit age')),
                  ],
                ),
              ],
            ),
            SizedBox(height: 50),
            ListTile(
              leading: Icon(Icons.mail),
              title: Text('Send a message'),
              onTap: () {
                showTodoSnackBar(context); // TODO
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Start chat'),
              onTap: () {
                showTodoSnackBar(context); // TODO
              },
            ),
            SizedBox(height: 10),
          ],
        ),
        UserTrophies(),
      ],
    );
  }
}
