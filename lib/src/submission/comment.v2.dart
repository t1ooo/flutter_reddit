import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reddit_prototype/src/util/date_time.dart';
import 'package:provider/provider.dart';

import '../comment/add_comment_screen.dart';
import '../notifier/reddir_notifier.dart';
import '../notifier/reddir_notifier.v4_1.dart';
import '../reddit_api/comment.dart';
import '../reddit_api/vote.dart';
import '../style/style.dart';
import '../user_profile/user_profile_screen.dart';
import '../util/snackbar.dart';
import '../widget/awards.dart';
import 'style.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({
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
            header(context, comment),
            if (notifier.expanded) ...[
              Text(comment.body),
              footer(context, comment),
              if (showNested)
                for (final reply in notifier.replies)
                  ChangeNotifierProvider<CommentNotifierQ>.value(
                    value: reply,
                    child: CommentWidget(
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

  Widget footer(BuildContext context, Comment comment) {
    return Row(
      children: [
        Spacer(),
        PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (_) => [
            _savePopupMenuItem(context),
            _sharePopupMenuItem(context, comment),
            _copyTextPopupMenuItem(context, comment),
            _collapsePopupMenuItem(context),
            // TODO
            PopupMenuItem(child: Text('Report')),
            PopupMenuItem(child: Text('Block user')),
          ],
        ),
        SizedBox(width: 20),
        Icon(Icons.star_outline),
        SizedBox(width: 20),
        IconButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return MultiProvider(
                    providers: [
                      ChangeNotifierProvider.value(
                        value: context.read<CommentNotifierQ>(),
                      ),
                    ],
                    child: AddCommentScreen(
                      id: comment.id,
                      isComment: true,
                    ),
                  );
                },
              ),
            );
          },
          icon: Icon(Icons.reply),
        ),
        SizedBox(width: 20),
        // Comment_voteButton(),
        _voteButton(context, comment),
      ],
    );
  }

  Widget header(BuildContext context, Comment comment) {
    return Row(
      children: [
        // Text(comment.body.substring(0,1) + ' '),
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
        Text(formatDateTime(comment.created)),
        Awards(
          awardIcons: comment.awardIcons,
          totalAwardsReceived: comment.totalAwardsReceived,
        ),
      ],
    );
  }

  PopupMenuItem _savePopupMenuItem(BuildContext context) {
    return PopupMenuItem(
      onTap: () async {
        final notifier = context.read<CommentNotifierQ>();

        final result = await (notifier.comment.saved
            ? notifier.unsave()
            : notifier.save());
        if (result != null) {
          showSnackBar(context, result);
        }
      },
      child: Builder(
        builder: (_) {
          final notifier = context.read<CommentNotifierQ>();

          return ListTile(
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: Icon(
              notifier.comment.saved ? Icons.bookmark : Icons.bookmark_border,
            ),
            title: Text(notifier.comment.saved ? 'Unsave' : 'Save'),
          );
        },
      ),
    );
  }

  PopupMenuItem _sharePopupMenuItem(BuildContext context, Comment comment) {
    return PopupMenuItem(
      onTap: () async {
        // Share.share('${comment.linkTitle} ${comment.shortLink}');
        context.read<CommentNotifierQ>().share();
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 0,
        leading: Icon(Icons.share),
        title: Text('Share'),
      ),
    );
  }

  PopupMenuItem _copyTextPopupMenuItem(BuildContext context, Comment comment) {
    return PopupMenuItem(
      onTap: () {
        Clipboard.setData(ClipboardData(text: comment.body));
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 0,
        leading: Icon(Icons.content_copy),
        title: Text('Copy text'),
      ),
    );
  }

  PopupMenuItem _collapsePopupMenuItem(BuildContext context) {
    return PopupMenuItem(
      onTap: () {
        context.read<CommentNotifierQ>().collapse();
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 0,
        leading: Icon(Icons.expand_less),
        title: Text('Collapse thread'),
      ),
    );
  }

  Widget _voteButton(BuildContext context, Comment comment) {
    final notifier = context.read<CommentNotifierQ>();

    return Row(
      children: [
        IconButton(
          onPressed: () async {
            // final result = await (comment.likes == Vote.up
            //     ? notifier.clearVote()
            //     : notifier.upVote());
            final result = await notifier.upVote();
            if (result != null) {
              showSnackBar(context, result);
            }
          },
          icon: Icon(
            Icons.expand_less,
            color: comment.likes == Vote.up ? Colors.green : null,
          ),
        ),
        Text(comment.score.toString()),
        IconButton(
          onPressed: () async {
            // final result = await (comment.likes == Vote.down
            //     ? notifier.clearVote()
            //     : notifier.downVote());
            final result = await notifier.downVote();
            if (result != null) {
              showSnackBar(context, result);
            }
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
