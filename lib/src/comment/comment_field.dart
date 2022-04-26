import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/comment/add_comment_screen.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import '../notifier/reddir_notifier.v4_1.dart';
import '../style/style.dart';

class CommentField extends StatelessWidget {
  const CommentField({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    // return Card(
    // color: Colors.red,

    return Container(
      // color:Colors.white,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
        color: Theme.of(context).cardColor,
      ),
      // color: Theme.of(context).cardColor,
      child: Padding(
        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        // padding: pagePadding,
        padding: pagePadding.copyWith(top: 10, bottom: 10),
        child: TextField(
          onTap: () {
            Navigator.push(
              context,
              // MaterialPageRoute(
              // builder: (_) => AddCommentScreen(id:id),
              // ),
              MaterialPageRoute(
                builder: (_) => AddCommentScreen(id: id),
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
