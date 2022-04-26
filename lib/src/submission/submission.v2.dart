import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/submission_tile.v2.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import 'comment.v2.dart';

class SubmissionWidget extends StatelessWidget {
  SubmissionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubmissionNotifierQ>();
    return /* Stack(
      children: [ */
        ListView(
      children: [
        SubmissionTile(
          activeLink: false,
        ),
        // Builder(builder: (context) {
        // final notifier = context.watch<SubmissionNotifier>();
        // print(notifier.submission.comments.length);
        // return Comments(comments: notifier.comments);
        // }),
        ListView(
          shrinkWrap: true,
          // return Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Comment(showNested: showNested),
            // Comment(showNested: showNested),
            // Comment(showNested: showNested),
            for (final comment in notifier.comments ?? [])
              ChangeNotifierProvider<CommentNotifierQ>.value(
                value: comment,
                child: CommentWidget(),
              ),
          ],
        ),
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
      // ),
      // Positioned(
      //   bottom: 0,
      //   left: 0,
      //   right: 0,
      //   child: CommentField(id: notifier.id),
      // ),
      // ],
    );
  }
}
