import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/logger.dart';
import 'package:flutter_reddit_prototype/src/reddit_api/submission_type.dart';
import 'package:flutter_reddit_prototype/src/widget/swipe_to_refresh.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../submission_tile/submission_tiles.dart';
import '../util/snackbar.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<HomeFrontNotifierQ>();

    return SwipeToRefresh(
      onRefresh: () => notifier
          .reloadSubmissions()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: GSubmissionTiles<FrontSubType>(
        type: notifier.subType,
        types: FrontSubType.values,
        submissions: notifier.submissions,
        onTypeChanged: (type) => notifier
            .loadSubmissions(type)
            .catchError((e) => showErrorSnackBar(context, e)),
      ),
    );
  }
}
