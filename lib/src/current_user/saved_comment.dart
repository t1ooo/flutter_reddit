import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reddit_prototype/src/util/date_time.dart';
import 'package:provider/provider.dart';

import '../reply/reply_screen.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/comment.dart';
import '../reddit_api/vote.dart';
import '../style/style.dart';
import '../submission/style.dart';
import '../submission/submission_screen.dart';
import '../subreddit/subreddit_screen.dart';
import '../user_profile/user_profile_screen.dart';
import '../util/snackbar.dart';
import '../widget/awards.dart';
import '../widget/custom_popup_menu_button.dart';

class SavedComment extends StatelessWidget {
  const SavedComment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<CommentNotifierQ>();
    final comment = notifier.comment;

    if (!comment.saved) {
      return Container();
    }

    return InkWell(
      onTap: comment.submissionId == ''
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SubmissionScreen(id: comment.submissionId),
                ),
              );
            },
      child: Card(
        child: Padding(
          padding: cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(context, notifier),
              Text(comment.body),
              footer(context, notifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget header(BuildContext context, CommentNotifierQ notifier) {
    final comment = notifier.comment;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          comment.linkTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(comment.author),
            Text(' • '),
            Text(comment.subredditNamePrefixed),
            Text(' • '),
            if (comment.isSubmitter) ...[
              Text('OP'),
              Text(' • '),
            ],

            Text(formatDateTime(comment.created)),
            // InkWell(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) => UserProfileScreen(name: comment.author),
            //       ),
            //     );
            //   },
            //   child: Text(
            //     comment.author,
            //     style: TextStyle(color: selectedColor),
            //   ),
            // ),
            // Text(' • '),
            // InkWell(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) =>
            //             SubredditScreenLoader(name: comment.subreddit),
            //       ),
            //     );
            //   },
            //   child: Text(
            //     comment.subredditNamePrefixed,
            //     style: TextStyle(color: selectedColor),
            //   ),
            // ),
            // Text(' • '),
            // Text(formatDateTime(comment.created)),
            // Awards(
            //   awardIcons: comment.awardIcons,
            //   totalAwardsReceived: comment.totalAwardsReceived,
            // ),
          ],
        ),
        SizedBox(height: 10),
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
        TextButton.icon(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider<CommentNotifierQ>.value(
                  value: context.read<CommentNotifierQ>(),
                  child: ReplyScreen(
                    id: comment.id,
                    isComment: true,
                  ),
                ),
              ),
            );
          },
          icon: Icon(Icons.reply),
          label: Text('Reply'),
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
            // return (comment.saved ? notifier.unsave() : notifier.save()).then(
            // (_) => context.read<UserNotifierQ>().refresh(),
            // onError: (e) => showErrorSnackBar(context, e));
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

        // TODO
        CustomPopupMenuItem(
            icon: Icon(Icons.circle), label: 'Report', onTap: () {}),
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
