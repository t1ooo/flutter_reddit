import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/util/date_time.dart';
import 'package:flutter_reddit_prototype/src/widget/save.dart';
import 'package:provider/provider.dart';

import '../reply/reply_screen.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../style/style.dart';
import '../submission/comment_popup_menu.dart';
import '../submission/submission_screen.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/like.dart';

class SavedComment extends StatelessWidget {
  const SavedComment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<CommentNotifier>();
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
              _header(context, notifier),
              Text(comment.body),
              _footer(context, notifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, CommentNotifier notifier) {
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
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _footer(BuildContext context, CommentNotifier notifier) {
    return Row(
      children: [
        Spacer(),
        // _popupMenuButton(context, notifier),
        CommentPopupMenu(showCollapse: false),
        SizedBox(width: 20),
        TextButton.icon(
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
          label: Text('Reply'),
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
  //   final comment = notifier.comment;

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

  //       // TODO
  //       CustomPopupMenuItem(
  //           icon: Icon(Icons.circle), label: 'Report', onTap: () {}),
  //     ],
  //   );
  // }
}
