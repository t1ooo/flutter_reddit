import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/notifier/reddir_notifier.dart';
import 'package:provider/provider.dart';

import '../comment/comment_field.dart';
import '../home/submission_tile.dart';
import '../provider.dart';
import '../reddit_api/submission.dart';
import 'comments.dart';

class SubmissionWidget extends StatelessWidget {
  SubmissionWidget({Key? key, required this.initSubmission}) : super(key: key);

  final Submission initSubmission;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        submissionNotifierProvider(initSubmission),
      ],
      child: Builder(builder: builder),
    );
  }

  Widget builder(BuildContext context) {
    // final notifier = context.watch<SubmissionNotifier>();
    print('build SubmissionWidget');
    return Stack(
      children: [
        ListView(
          children: [
            SubmissionTile(
              submission: initSubmission,
              activeLink: false,
            ),
            Builder(builder: (context) {
              final notifier = context.watch<SubmissionNotifier>();
              print(notifier.submission.comments.length);
              return Comments(comments: notifier.submission.comments);
            }),
            // Comments(comments: notifier.submission.comments),

            // Positioned(
            //   left: 0,
            //   right: 0,
            //   bottom: 0,
            //   child: TextField(
            //     decoration: InputDecoration(
            //       helperText: 'Add a comment',
            //     ),
            //   ),
            // ),
            SizedBox(height: 100),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CommentField(id: initSubmission.id),
        ),
      ],
    );
  }
}
