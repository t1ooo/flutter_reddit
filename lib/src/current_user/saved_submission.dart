import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/submission_notifier.dart';
import '../submission_tile/submission_tile.dart';

class SavedSubmission extends StatelessWidget {
  const SavedSubmission({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubmissionNotifier>();
    final submission = notifier.submission;

    if (!submission.saved) {
      return Container();
    }
    return SubmissionTile();
  }
}
