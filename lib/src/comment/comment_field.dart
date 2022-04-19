import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/comment/add_comment_screen.dart';

import '../style/style.dart';

class CommentField extends StatelessWidget {
  const CommentField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: pagePadding,
        child: TextField(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddCommentScreen(onSubmit: (String ) {  },),
              ),
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
