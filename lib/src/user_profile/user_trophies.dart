import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/user_profile/user_comment.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/trophy.dart';
import '../reddit_api/user.dart';
import '../reddit_api/comment.dart';
import '../style/style.dart';
import '../util/date_time.dart';
import '../widget/custom_future_builder.dart';
import '../widget/stream_list_builder.dart';
import 'user_trophy.dart';

class UserTrophies extends StatelessWidget {
  const UserTrophies({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    // return CustomFutureBuilder(
    //   future: context.read<UserNotifier>().trophies(),
    //   onData: (BuildContext context, List<Trophy> trophies) {
    //     return ListView(
    //       shrinkWrap: true,
    //       children: [
    //         ListTile(title: Text('TROPHIES')),
    //         for (final trophy in trophies) UserTrophy(trophy: trophy)
    //       ],
    //     );
    //   },
    // );
    return Builder(
      builder: (context) {
        final notifier = context.watch<UserNotifierQ>();
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          notifier.loadTrophies();
        });
        final trophies = notifier.trophies;
        if (trophies == null) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView(
          shrinkWrap: true,
          children: [
            ListTile(title: Text('TROPHIES')),
            for (final trophy in trophies) UserTrophy(trophy: trophy)
          ],
        );
      },
    );
  }
}
