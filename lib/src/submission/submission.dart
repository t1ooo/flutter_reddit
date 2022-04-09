import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import '../home/submission_tile.dart';
import '../reddit_api/submission.dart';
import 'comments.dart';

class Submission extends StatelessWidget {
  const Submission({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SubmissionTile(
          submission: placeholderSubmission(),
          activeLink: false,
        ),
        Comments(),
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
  }
}
