import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reddit_prototype/src/util/date_time.dart';
import 'package:provider/provider.dart';

import '../reply/reply_screen.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/comment.dart';
import '../reddit_api/vote.dart';
import '../style/style.dart';
import '../user_profile/user_profile_screen.dart';
import '../util/snackbar.dart';
import '../widget/awards.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/icon_text.dart';
import 'style.dart';

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
    final notifier = context.watch<CommentNotifierQ>();
    final comment = notifier.comment;

    return InkWell(
      onTap: notifier.expanded
          ? null
          : () {
              notifier.expand();
            },
      child: Padding(
        padding: commentPadding(depth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(context, notifier),
            if (notifier.expanded) ...[
              Text(comment.body),
              footer(context, notifier),
              if (showNested)
                for (final reply in notifier.replies)
                  ChangeNotifierProvider<CommentNotifierQ>.value(
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

  Widget header(BuildContext context, CommentNotifierQ notifier) {
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

  Widget footer(BuildContext context, CommentNotifierQ notifier) {
    final comment = notifier.comment;

    return Row(
      children: [
        Spacer(),
        _popupMenuButton(context, notifier),
        SizedBox(width: 20),
        Icon(Icons.star_outline),
        SizedBox(width: 20),
        IconButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider<SubmissionNotifierQ>.value(
                      value: context.read<SubmissionNotifierQ>(),
                    ),
                    ChangeNotifierProvider<CommentNotifierQ>.value(
                      value: context.read<CommentNotifierQ>(),
                    ),
                  ],
                  child: ReplyScreen(
                    id: comment.id,
                    isComment: true,
                  ),
                ),
              ),
            );
          },
          icon: Icon(Icons.reply),
          // icon: IconText(icon: Icon(Icons.reply), text: Text('Reply')),
        ),
        SizedBox(width: 20),
        _voteButton(context, notifier),
      ],
    );
  }

  CustomPopupMenuButton _popupMenuButton(
    BuildContext context,
    CommentNotifierQ notifier,
  ) {
    final comment = notifier.comment;

    return CustomPopupMenuButton(
      icon: Icon(Icons.more_vert),
      items: [
        CustomPopupMenuItem(
          icon: Icon(
            comment.saved ? Icons.bookmark : Icons.bookmark_border,
          ),
          label: comment.saved ? 'Unsave' : 'Save',
          onTap: () {
            return (comment.saved ? notifier.unsave() : notifier.save())
                .catchError((e) => showErrorSnackBar(context, e));
          },
        ),

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

        CustomPopupMenuItem(
          icon: Icon(Icons.expand_less),
          label: 'Collapse thread',
          onTap: () {
            notifier.collapse();
          },
        ),

        // TODO
        CustomPopupMenuItem(
            icon: Icon(Icons.circle), label: 'Report', onTap: () {}),
        CustomPopupMenuItem(
            icon: Icon(Icons.circle), label: 'Block user', onTap: () {}),
      ],
    );
  }

  Widget _voteButton(BuildContext context, CommentNotifierQ notifier) {
    final comment = notifier.comment;

    return Row(
      children: [
        IconButton(
          onPressed: () {
            notifier.upVote().catchError((e) => showErrorSnackBar(context, e));
          },
          icon: Icon(
            Icons.expand_less,
            color: comment.likes == Vote.up ? Colors.green : null,
          ),
        ),
        Text(comment.score.toString()),
        // TODO: disable on progress
        IconButton(
          onPressed: () {
            notifier
                .downVote()
                .catchError((e) => showErrorSnackBar(context, e));
          },
          icon: Icon(
            Icons.expand_more,
            color: comment.likes == Vote.down ? Colors.red : null,
          ),
        ),
      ],
    );
  }
}
