import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../comment/comment_field.dart';
import 'submission.v2.dart';

class SubmissionScreen extends StatelessWidget {
  const SubmissionScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    // final notifer = context.watch<SubmissionNotifier>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Submission'),
      ),
      body: Padding(
        padding: pagePadding,
        // TODO: replace to Loader
        child: Builder(builder: (context) {
          final notifier = context.read<SubmissionLoaderNotifierQ>();
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            notifier.loadSubmission(id);
          });
          final submission = notifier.submission;
          if (submission == null) {
            return Center(child: CircularProgressIndicator());
          }
          return ChangeNotifierProvider<SubmissionNotifierQ>.value(
            value: submission,
            child: SubmissionWidget(),
          );
        }),
      ),
      bottomNavigationBar: CommentField(id: id),
    );
  }
}
