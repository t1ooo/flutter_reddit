import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/util/date_time.dart';

import '../reddit_api/comment.dart';
import '../style/style.dart';
import '../user_profile/user_profile_screen.dart';
import '../widget/sized_placeholder.dart';
import 'style.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    Key? key,
    required this.comment,
    this.depth = 0,
    this.showNested = true,
  }) : super(key: key);

  final Comment comment;
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
    return Padding(
      padding: commentPadding(depth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedPlaceholder(width: 20, height: 20),
              SizedBox(width: 10),
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
              Text(' * '),
              Text(formatDateTime(comment.created)),
            ],
          ),
          Text(comment.body),
          Row(
            // alignment: WrapAlignment.end,
            // crossAxisAlignment: WrapCrossAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Spacer(),
              Text('...'),
              SizedBox(width: 20),
              Icon(Icons.star_outline),
              SizedBox(width: 20),
              Icon(Icons.reply),
              Text('Reply'),
              SizedBox(width: 20),
              // Icon(Icons.thumb_up),
              Icon(Icons.expand_less),
              Text(comment.ups.toString()),
              Icon(Icons.expand_more),
            ],
          ),
          if (showNested)
            for (var reply in comment.replies)
              CommentWidget(
                comment: reply,
                showNested: showNested,
                depth: depth + 1,
              )
        ],
      ),
    );
  }
}
