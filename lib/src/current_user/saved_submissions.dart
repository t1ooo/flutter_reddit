import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../submission_tile/submission_tile.dart';
import '../widget/snackbar.dart';
import '../widget/loader.dart';
import '../widget/swipe_to_refresh.dart';

class SavedSubmissions extends StatelessWidget {
  const SavedSubmissions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserNotifier>();

    return SwipeToRefresh(
      onRefresh: () => notifier
          .reloadSaved()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: Loader<List<SubmissionNotifier>>(
        load: (_) => notifier.loadSaved(),
        data: (_) => notifier.savedSubmissions,
        onData: (_, submissions) {
          return ListView(
            shrinkWrap: true,
            children: [
              for (final sub in submissions)
                ChangeNotifierProvider<SubmissionNotifier>.value(
                  value: sub,
                  child: Builder(builder: (context) {
                    return context.watch<SubmissionNotifier>().submission.saved
                        ? SubmissionTile()
                        : Container();
                  }),
                ),
            ],
          );
        },
      ),
    );
  }
}
