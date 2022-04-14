import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import '../provider.dart';
import '../reddit_api/comment.dart';
import '../reddit_api/submission.dart';

class SubmissionSaveButton extends StatelessWidget {
  const SubmissionSaveButton({
    Key? key,
    required this.submission,
  }) : super(key: key);

  final Submission submission;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [submissionSaveNotifierProvider(submission)],
      child: Builder(
        builder: (c) {
          final notifier = c.watch<SubmissionSaveNotifier>();
          final error = notifier.error;
          if (error != null) {
            // TODO: handle error
          }
          return Row(
            children: [
              IconButton(
                onPressed: () async {
                  notifier.saved
                      ? notifier.unsave(submission.id)
                      : notifier.save(submission.id);
                },
                icon: Icon(
                  notifier.saved ? Icons.bookmark : Icons.bookmark_border,
                  // color: notifier.saved ? Colors.green : null,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
