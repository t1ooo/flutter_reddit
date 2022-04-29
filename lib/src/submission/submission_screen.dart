import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../comment/comment_field.dart';
import '../widget/loader.dart';
import 'submission.dart';

class SubmissionScreen extends StatelessWidget {
  const SubmissionScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submission'),
      ),
      body: Padding(
        padding: pagePadding,
        child: Loader<SubmissionNotifierQ>(
          load: (context) => context.read<SubmissionLoaderNotifierQ>().loadSubmission(id),
          data: (context) => context.read<SubmissionLoaderNotifierQ>().submission,
          onData: (context, submission) {
            return ChangeNotifierProvider<SubmissionNotifierQ>.value(
              value: submission,
              child: SubmissionWidget(),
            );
          },
        ),
      ),
      bottomNavigationBar: CommentField(id: id),
    );
  }
}
