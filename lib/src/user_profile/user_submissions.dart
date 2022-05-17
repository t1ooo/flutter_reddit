import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/widget/swipe_to_refresh.dart';
import 'package:provider/provider.dart';

import '../submission_tile/submission_tile.dart';
import '../notifier/reddir_notifier.v4_2.dart';

import '../util/snackbar.dart';
import '../widget/loader.dart';

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
          return ListView(
            shrinkWrap: true,
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
