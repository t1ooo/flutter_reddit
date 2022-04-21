import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/notifier/reddir_notifier.dart';

import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:flutter_reddit_prototype/src/widget/custom_future_builder.dart';
import 'package:provider/provider.dart';

import '../reddit_api/submission.dart';
import '../comment/comment_field.dart';
import 'submission.dart';

class SubmissionScreen extends StatelessWidget {
  const SubmissionScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  // @override
  // Widget build(BuildContext context) {
  //   // final notifer = context.watch<SubmissionNotifier>();
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Submission'),
  //     ),
  //     // body: Submission(),
  //     body: CustomFutureBuilder(
  //       future: context.read<RedditNotifier>().submission(id),
  //       // future: notifer.load(id),
  //       onData: (BuildContext context, Submission submission) {
  //         return SubmissionWidget(submission: submission);
  //       },
  //     ),
  //     // bottomNavigationBar: CommentField(),
  //     bottomNavigationBar: CommentField(id:id),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // final notifer = context.watch<SubmissionNotifier>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Submission'),
      ),
      // body: Submission(),
      body: Padding(
        padding: pagePadding,
        child: CustomFutureBuilder(
          future: context.read<RedditNotifier>().submission(id),
          // future: notifer.load(id),
          onData: (BuildContext context, Submission submission) {
            return SubmissionWidget(initSubmission: submission);
          },
        ),
      ),
      // bottomNavigationBar: CommentField(),
      // bottomNavigationBar: CommentField(id:id),
    );
  }
}


class SubmissionScreenV2 extends StatelessWidget {
  const SubmissionScreenV2({
    Key? key,
    required this.submission,
  }) : super(key: key);

  final Submission submission;

  @override
  Widget build(BuildContext context) {
    // final notifer = context.watch<SubmissionNotifier>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Submission'),
      ),
      // body: Submission(),
      body: SubmissionWidget(initSubmission: submission),
      // bottomNavigationBar: CommentField(),
      // bottomNavigationBar: CommentField(id:id),
    );
  }
}
