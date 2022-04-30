import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/reddit_api/submission_type.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../submission_tile/submission_tiles.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<HomeFrontNotifierQ>();
    return GSubmissionTiles<FrontSubType>(
      type: notifier.subType,
      types: FrontSubType.values,
      submissions: notifier.submissions,
      onTypeChanged: notifier.loadSubmissions,
    );
  }
}
