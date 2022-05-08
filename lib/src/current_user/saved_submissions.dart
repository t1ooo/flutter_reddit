import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../submission_tile/submission_tile.dart';
import '../widget/loader.dart';

class SavedSubmissions extends StatelessWidget {
  const SavedSubmissions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserNotifierQ>();

    return Loader<List<SubmissionNotifierQ>>(
      load: (_) => notifier.loadSaved(),
      data: (_) => notifier.savedSubmissions,
      onData: (_, submissions) {
        return ListView(
          shrinkWrap: true,
          children: [
            for (final sub in submissions)
              ChangeNotifierProvider<SubmissionNotifierQ>.value(
                value: sub,
                child: Builder(
                  builder: (context) {
                    final submission = context.watch<SubmissionNotifierQ>().submission;
                    if (!submission.saved) {
                     return Container();
                    }
                    return SubmissionTile();
                  }
                ),
              ),
          ],
        );
      },
    );
  }
}
