import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/submission_notifier.dart';
import '../notifier/user_notifier.dart';
import '../submission_tile/submission_tile.dart';
import '../widget/list.dart';
import '../widget/loader.dart';
import '../widget/snackbar.dart';
import '../widget/swipe_to_refresh.dart';

class UserSubmissions extends StatelessWidget {
  const UserSubmissions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserNotifier>();

    return SwipeToRefresh(
      onRefresh: () => notifier
          .reloadSubmissions()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: Loader<List<SubmissionNotifier>>(
        load: (_) => notifier.loadSubmissions(),
        data: (_) => notifier.submissions,
        onData: (_, submissions) {
          return CustomListView(
            children: [
              for (final sub in submissions)
                ChangeNotifierProvider<SubmissionNotifier>.value(
                  value: sub,
                  child: SubmissionTile(),
                ),
            ],
          );
        },
      ),
    );
  }
}
