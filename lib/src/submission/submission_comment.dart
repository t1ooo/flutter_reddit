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
import '../style/style.dart';
import '../user_profile/user_profile_screen.dart';
import '../widget/awards.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/like.dart';
import '../widget/save.dart';
import 'comment_popup_menu.dart';

class SubmissionComment extends StatelessWidget {
  const SubmissionComment({
    Key? key,
    this.depth = 0,
    this.showNested = true,
  }) : super(key: key);

  final int depth;
  final bool showNested;

  @override
  Widget build(BuildContext context) {
    if (depth == 0) {
      return withCard(context);
    }
    return body(context);
  }

  Widget withCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: cardPadding,
        child: body(context),
      ),
    );
  }

  Widget body(BuildContext context) {
    final notifier = context.watch<CommentNotifier>();
    final comment = notifier.comment;

    return InkWell(
      onTap: notifier.expanded
          ? null
          : () {
              notifier.expand();
            },
      child: Padding(
        padding: _commentPadding(depth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(context, notifier),
            if (notifier.expanded) ...[
              Text(comment.body),
              footer(context, notifier),
              if (showNested)
                for (final reply in notifier.replies)
                  ChangeNotifierProvider<CommentNotifier>.value(
                    value: reply,
                    child: SubmissionComment(
                      showNested: showNested,
                      depth: depth + 1,
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }

  Widget header(BuildContext context, CommentNotifier notifier) {
    final comment = notifier.comment;

    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserProfileScreen(name: comment.author),
              ),
            );
          },
          child: Text(comment.author),
        ),
        Text(' • '),
        if (comment.isSubmitter) ...[
          Text('OP'),
          Text(' • '),
        ],
        Text(formatDateTime(comment.created)),
        Awards(
          awardIcons: comment.awardIcons,
          totalAwardsReceived: comment.totalAwardsReceived,
        ),
      ],
    );
  }

  Widget footer(BuildContext context, CommentNotifier notifier) {
    return Row(
      children: [
        Spacer(),
        // _popupMenuButton(context, notifier),
        CommentPopupMenu(),
        SizedBox(width: 20),
        Icon(Icons.star_outline),
        SizedBox(width: 20),
        IconButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InheritedProvider<Replyable>.value(
                  value: context.read<CommentNotifier>(),
                  child: ReplyScreen(),
                ),
              ),
            );
          },
          icon: Icon(Icons.reply),
        ),
        SizedBox(width: 20),
        LikeButton(likable: notifier),
      ],
    );
  }

  // CustomPopupMenuButton _popupMenuButton(
  //   BuildContext context,
  //   CommentNotifier notifier,
  // ) {
  //   return CustomPopupMenuButton(
  //     icon: Icon(Icons.more_vert),
  //     items: [
  //       savePopupMenuItem(context, notifier),

  //       CustomPopupMenuItem(
  //         icon: Icon(Icons.share),
  //         label: 'Share',
  //         onTap: () async {
  //           return notifier.share();
  //         },
  //       ),

  //       CustomPopupMenuItem(
  //         icon: Icon(Icons.content_copy),
  //         label: 'Copy Text',
  //         onTap: () async {
  //           return notifier.copyText();
  //         },
  //       ),

  //       CustomPopupMenuItem(
  //         icon: Icon(Icons.expand_less),
  //         label: 'Collapse thread',
  //         onTap: () {
  //           notifier.collapse();
  //         },
  //       ),

  //       // TODO
  //       CustomPopupMenuItem(
  //           icon: Icon(Icons.circle), label: 'Report', onTap: () {}),
  //       // CustomPopupMenuItem(
  //           // icon: Icon(Icons.circle), label: 'Block user', onTap: () {}),
  //     ],
  //   );
  // }

  EdgeInsets _commentPadding([int depth = 0]) {
    const padding = 5.0;
    const commentMaxDepth = 3;
    final leftPadding = (depth <= commentMaxDepth ? depth : 0) * 30.0;

    return EdgeInsets.only(
      left: leftPadding,
      top: padding,
      bottom: padding,
    );
  }
}
