import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/submission_tile.dart';
import '../notifier/reddir_notifier.v4_2.dart';
// import '../widget/stream_list_builder.dart';
import '../widget/loader.dart';

class UserSubmissions extends StatelessWidget {
  const UserSubmissions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Loader<List<SubmissionNotifierQ>>(
      load: (context) => context.read<UserNotifierQ>().loadSubmissions(),
      data: (context) => context.read<UserNotifierQ>().submissions,
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
  }
}
