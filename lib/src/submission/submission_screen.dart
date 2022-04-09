import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import 'comment_field.dart';
import 'submission.dart';

class SubmissionScreen extends StatelessWidget {
  const SubmissionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submission'),
      ),
      body: Submission(),
      bottomNavigationBar: CommentField(),
    );
  }
}
