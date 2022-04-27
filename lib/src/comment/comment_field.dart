import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/comment/add_comment_screen.dart';

import '../style/style.dart';

class CommentField extends StatelessWidget {
  const CommentField({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: pagePadding.copyWith(top: 10, bottom: 10),
        child: TextField(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddCommentScreen(id: id)),
            );
          },
          decoration: InputDecoration(
            hintText: 'Add a comment',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
