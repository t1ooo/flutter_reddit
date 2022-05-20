import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/util/date_time.dart';
import 'package:provider/provider.dart';

import '../reply/reply_screen.dart';
import '../notifier/auth_notifier.dart';
import '../notifier/collapse_mixin.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/current_user_notifier.dart';
import '../notifier/home_front_notifier.dart';
import '../notifier/home_popular_notifier.dart';
import '../notifier/iterable_sum.dart';
import '../notifier/likable_mixin.dart';
import '../notifier/limit.dart';
import '../notifier/list_notifier.dart';
import '../notifier/message_notifier.dart';
import '../notifier/property_listener.dart';
import '../notifier/replyable.dart';
import '../notifier/reportable.dart';
import '../notifier/rule_notifier.dart';
import '../notifier/savable_mixin.dart';
import '../notifier/score.dart';
import '../notifier/search_notifier.dart';
import '../notifier/search_subreddits.dart';
import '../notifier/submission_loader_notifier.dart';
import '../notifier/submission_notifier.dart';
import '../notifier/submissions_notifier.dart';
import '../notifier/subreddit_loader_notifier.dart';
import '../notifier/subreddit_notifier.dart';
import '../notifier/try_mixin.dart';
import '../notifier/user_loader_notifier.dart';
import '../notifier/user_notifier.dart';
import '../report/report_screen.dart';
import '../style/style.dart';
import '../user_profile/user_profile_screen.dart';
import '../widget/awards.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/like.dart';
import '../widget/save.dart';

class CommentPopupMenu extends StatelessWidget {
  const CommentPopupMenu({
    Key? key,
    this.showCollapse = true,
  }) : super(key: key);

  final bool showCollapse;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<CommentNotifier>();

    return CustomPopupMenuButton(
      icon: Icon(Icons.more_vert),
      items: [
        savePopupMenuItem(context, notifier),

        CustomPopupMenuItem(
          icon: Icon(Icons.share),
          label: 'Share',
          onTap: () async {
            return notifier.share();
          },
        ),

        CustomPopupMenuItem(
          icon: Icon(Icons.content_copy),
          label: 'Copy Text',
          onTap: () async {
            return notifier.copyText();
          },
        ),

        if (showCollapse)
          CustomPopupMenuItem(
            icon: Icon(Icons.expand_less),
            label: 'Collapse thread',
            onTap: () {
              notifier.collapse();
            },
          ),

        CustomPopupMenuItem(
          icon: Icon(Icons.circle),
          label: 'Report',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InheritedProvider<Reportable>.value(
                  value: notifier,
                  child: ReportScreen(),
                ),
              ),
            );
          },
        ),
        // CustomPopupMenuItem(
        // icon: Icon(Icons.circle), label: 'Block user', onTap: () {}),
      ],
    );
  }
}
