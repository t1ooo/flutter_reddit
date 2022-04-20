import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import '../comment/comment_field.dart';
import '../home/submission_tile.dart';
import '../reddit_api/submission.dart';
import 'comments.dart';

class SubmissionWidget extends StatelessWidget {
  SubmissionWidget({Key? key, required this.submission}) : super(key: key);

  final Submission submission;

  @override
  Widget build(BuildContext context) {
    return /* Stack(
      children: [ */
        ListView(
          children: [
            SubmissionTile(
              submission: submission,
              activeLink: false,
            ),
            Comments(comments: submission.comments),

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
          ],
        );
        // Positioned(
        //   bottom: 0,
        //   left: 0,
        //   right: 0,
        //   child: CommentField(id:submission.id),
        // ),
      /* ],
    ); */
  }
}
