import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/home_popular_notifier.dart';
import '../reddit_api/submission_type.dart';
import '../submission_tile/submission_tiles.dart';
import '../widget/pull_to_refresh.dart';
import '../widget/snackbar.dart';

class Popular extends StatelessWidget {
  const Popular({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<HomePopularNotifier>();

    return PullToRefresh(
      onRefresh: () => notifier
          .reloadSubmissions()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: SubmissionTiles<SubType>(
        key: PageStorageKey(runtimeType.toString()),
        type: notifier.subType,
        types: SubType.values,
        submissions: notifier.submissions,
        load: notifier.loadSubmissions,
      ),
    );
  }
}
