import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/submission_tile.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../widget/loader.dart';

class SavedComments extends StatelessWidget {
  const SavedComments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Loader<List<SubmissionNotifierQ>>(
      // TODO: replace watch -> read
      load: (context) => context.watch<UserNotifierQ>().loadSaved(),
      data: (context) => context.watch<UserNotifierQ>().savedSubmissions,
      onData: (context, submissions) {
        return ListView(
          shrinkWrap: true,
          children: [
            for (final sub in submissions)
              ChangeNotifierProvider<SubmissionNotifierQ>.value(
                value: sub,
                child: SubmissionTile(),
              ),
          ],
        );
      },
    );
    /* return Builder(
      builder: (context) {
        final submissions =
            context.select<UserNotifierQ, List<SubmissionNotifierQ>?>(
                (v) => v.savedSubmissions);
        if (submissions == null) {
          return CircularProgressIndicator();
        }
        return ListView(
          shrinkWrap: true,
          children: [
            for (final sub in submissions)
              ChangeNotifierProvider<SubmissionNotifierQ>.value(
                value: sub,
                child: SubmissionTile(),
              ),
          ],
        );
      },
    ); */
  }
}
