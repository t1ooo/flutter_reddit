import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/style/style.dart';

import 'add_comment.dart';

class AddCommentScreen extends StatelessWidget {
  const AddCommentScreen({
    Key? key,
    required this.id,
    this.isComment = false,
  }) : super(key: key);

  final String id;
  final bool isComment;
  // final Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add comment'),
      ),
      body: Padding(
        padding: pagePadding,
        child: AddComment(id: id, isComment: isComment),
      ),
    );
  }
}
