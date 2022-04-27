import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/submission_type.dart';
import 'submission_tiles.dart';

class Popular extends StatelessWidget {
  const Popular({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final notifier = context.watch<HomePopularNotifierQ>();
        return GSubmissionTiles<SubType>(
          type: notifier.subType,
          types: SubType.values,
          submissions: notifier.submissions,
          onTypeChanged: notifier.loadSubmissions,
        );
      },
    );
  }
}
