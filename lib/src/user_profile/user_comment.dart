import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/submission/submission_screen.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../style/style.dart';
import '../submission/style.dart';

class UserComment extends StatelessWidget {
  const UserComment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Card(
    //   child: Padding(
    //     padding: cardPadding,
    //     child: body(context),
    //   ),
    // );
    return Container(color: Theme.of(context).primaryColor,child: body(context));
  }

  Widget body(BuildContext context) {
    final notifier = context.read<CommentNotifierQ>();
    final comment = notifier.comment;
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        // padding: commentPadding(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comment.linkTitle, textScaleFactor: 2),
            Row(
              children: [
                Text(comment.subredditNamePrefixed),
                Text(' • '),
                Text(comment.created.toString()),
                Text(' • '),
                Text(comment.ups.toString()),
              ],
            ),
            SizedBox(height: 10),
            Text(comment.body),
            Text(comment.isSubmitter.toString()),
            Divider(),
          ],
        ),
      ),
    );
  }
}
