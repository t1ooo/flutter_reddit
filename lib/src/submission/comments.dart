import 'package:flutter/material.dart';

import '../reddit_api/comment.dart';
import 'comment.dart';


class Comments extends StatelessWidget {
  const Comments({
    Key? key,
    required this.comments,
    this.showNested = true,
  }) : super(key: key);

  final bool showNested;
  final List<Comment> comments;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      // return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Comment(showNested: showNested),
        // Comment(showNested: showNested),
        // Comment(showNested: showNested),
        for (final comment in comments)
          CommentWidget(initComment:comment, showNested: showNested)
      ],
    );
  }
}
