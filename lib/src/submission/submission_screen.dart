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
    final notifier = context.read<SubmissionLoaderNotifierQ>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Submission'),
      ),
      body: Padding(
        padding: pagePadding,
        child: Loader<SubmissionNotifierQ>(
          load: (_) => notifier.loadSubmission(id),
          data: (_) => notifier.submission,
          onData: (_, submission) {
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
