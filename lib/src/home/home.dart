import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/home_front_notifier.dart';
import '../reddit_api/submission_type.dart';
import '../submission_tile/submission_tiles.dart';
import '../widget/pull_to_refresh.dart';
import '../widget/snackbar.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<HomeFrontNotifier>();

    return PullToRefresh(
      onRefresh: () => notifier
          .reloadSubmissions()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: SubmissionTiles<FrontSubType>(
        key: PageStorageKey(runtimeType.toString()),
        type: notifier.subType,
        types: FrontSubType.values,
        submissions: notifier.submissions,
        load: notifier.loadSubmissions,
      ),
    );
  }
}
