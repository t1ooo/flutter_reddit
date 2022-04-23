import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/submission/submission_screen.dart';
import 'package:flutter_reddit_prototype/src/user_profile/user_comment.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import '../reddit_api/comment.dart';
import '../style/style.dart';
import '../submission/comments.dart';
import '../submission/style.dart';
import '../user_profile/user_profile_screen.dart';
import '../widget/sized_placeholder.dart';
import '../widget/stream_list_builder.dart';

class UserComments extends StatelessWidget {
  const UserComments({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pagePadding,
      child: StreamListBuilder(
        // stream: context.read<RedditNotifier>().userComments(name),
        stream: context.read<UserCommentsNotifier>().comments(),
        onData: (context, List<Comment> comments) {
          // return Comments(comments:comments);
          return ListView(
            children: [
              for (final comment in comments) UserComment(comment: comment),
            ],
          );
        },
      ),
    );
  }
}
