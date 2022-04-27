import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/user_profile/user_comment.dart';
import 'package:flutter_reddit_prototype/src/util/snackbar.dart';
import 'package:provider/provider.dart';

import '../home/submission_tile.v2.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/trophy.dart';
import '../reddit_api/user.dart';
import '../reddit_api/comment.dart';
import '../style/style.dart';
import '../util/date_time.dart';
import '../widget/custom_future_builder.dart';
// import '../widget/stream_list_builder.dart';
import '../widget/loader.v2.dart';
import 'user_trophy.dart';

class UserSubmissions extends StatelessWidget {
  const UserSubmissions({
    Key? key,
    // required this.user,
  }) : super(key: key);

  // final User user;

  @override
  Widget build(BuildContext context) {
    // return CustomFutureBuilder(
    //   future: context.read<UserNotifier>().submissions(),
    //   onData: (BuildContext context, List<Trophy> submissions) {
    //     return ListView(
    //       shrinkWrap: true,
    //       children: [
    //         ListTile(title: Text('TROPHIES')),
    //         for (final trophy in submissions) UserTrophy(trophy: trophy)
    //       ],
    //     );
    //   },
    // );
    // return Builder(
    //   builder: (context) {
    //     final notifier = context.watch<UserNotifierQ>();
    //     WidgetsBinding.instance?.addPostFrameCallback((_) {
    //       notifier.loadSubmissions();
    //     });
    //     final submissions = notifier.submissions;
    //     if (submissions == null) {
    //       return Center(child: CircularProgressIndicator());
    //     }
    //     return ListView(
    //       shrinkWrap: true,
    //       children: [
    //         ListTile(title: Text('TROPHIES')),
    //         for (final trophy in submissions) UserTrophy(trophy: trophy)
    //       ],
    //     );
    //   },
    // );

    // return Loader<List<Trophy>?>(
    //   load: (context) => context.watch<UserNotifierQ>().loadSubmissions(),
    //   data: (context) => context.watch<UserNotifierQ>().submissions,
    //   builder: (context, submissions, error) {
    //     if (error != null) {
    //       showErrorSnackBar(context, error);
    //       return Container();
    //     }
    //     if (submissions == null) {
    //       return Center(child: CircularProgressIndicator());
    //     }
    //     return ListView(
    //       shrinkWrap: true,
    //       children: [
    //         ListTile(title: Text('TROPHIES')),
    //         for (final trophy in submissions) UserTrophy(trophy: trophy)
    //       ],
    //     );
    //   },
    // );

    return Loader<List<SubmissionNotifierQ>>(
      load: (context) => context.watch<UserNotifierQ>().loadSubmissions(),
      data: (context) => context.watch<UserNotifierQ>().submissions,
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
