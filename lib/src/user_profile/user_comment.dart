import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/submission/submission_screen.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../util/date_time.dart';

class UserComment extends StatelessWidget {
  const UserComment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<CommentNotifier>();
    final comment = notifier.comment;

    return Container(
      color: Theme.of(context).primaryColor,
      child: InkWell(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.linkTitle,
                textScaleFactor: 1.7,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(comment.subredditNamePrefixed),
                  Text(' • '),
                  Text(formatDateTime(comment.created)),
                ],
              ),
              SizedBox(height: 10),
              Text(comment.body),
              Text(comment.isSubmitter.toString()),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
