import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/submission_notifier.dart';
import '../notifier/user_notifier.dart';
import '../widget/list.dart';
import '../widget/loader.dart';
import '../widget/pull_to_refresh.dart';
import '../widget/snackbar.dart';
import 'saved_submission.dart';

class SavedSubmissions extends StatelessWidget {
  const SavedSubmissions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserNotifier>();

    return PullToRefresh(
      onRefresh: () => notifier
          .reloadSaved()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: Loader<List<SubmissionNotifier>>(
        load: (_) => notifier.loadSaved(),
        data: (_) => notifier.savedSubmissions,
        onData: (_, submissions) {
          return CustomListView(
            key: PageStorageKey(runtimeType.toString()),
            children: [
              for (final sub in submissions)
                ChangeNotifierProvider<SubmissionNotifier>.value(
                  value: sub,
                  child: SavedSubmission(),
                ),
            ],
          );
        },
      ),
    );
  }
}
