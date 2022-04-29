import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../submission_tile/submission_tile.dart';
import '../notifier/reddir_notifier.v4_2.dart';
// import '../widget/stream_list_builder.dart';
import '../widget/loader.dart';

class UserSubmissions extends StatelessWidget {
  const UserSubmissions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserNotifierQ>();
    return Loader<List<SubmissionNotifierQ>>(
      load: (_) => notifier.loadSubmissions(),
      data: (_) => notifier.submissions,
      onData: (_, submissions) {
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
  }
}


class UserSubmissionsLoader extends StatelessWidget {
  const UserSubmissionsLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<UserNotifierQ>();
    return Loader<List<SubmissionNotifierQ>>(
      load: (_) => notifier.loadSubmissions(),
      data: (_) => notifier.submissions,
      onData: (_, __) {
        return UserSubmissions();
      },
    );
  }
}
