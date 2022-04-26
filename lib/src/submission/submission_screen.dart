import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../comment/comment_field.dart';
import '../util/snackbar.dart';
import 'submission.v2.dart';

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
        child: Builder(builder: (context) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            context.read<SubmissionNotifierQ>().loadSubmission(id);
            // final result = context.read<SubmissionNotifierQ>().loadSubmission(id);
            // if (result is Reload) {
              
            // }
            // if (result is Error) {
            //   showSnackBar(context, result.toString());
            // }
          });
          return SubmissionWidget();
        }),
      ),
      bottomNavigationBar: CommentField(id: id),
      // floatingActionButton: FloatingActionButton(child:Icon(Icons.update), onPressed: () {},),
    );
  }
}


/* class SubmissionScreenV2 extends StatelessWidget {
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
} */
