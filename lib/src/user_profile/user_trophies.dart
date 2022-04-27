import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/trophy.dart';
import '../widget/loader.dart';
import 'user_trophy.dart';

class UserTrophies extends StatelessWidget {
  const UserTrophies({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Loader<List<Trophy>>(
      load: (context) => context.watch<UserNotifierQ>().loadTrophies(),
      data: (context) => context.watch<UserNotifierQ>().trophies,
      onData: (context, trophies) {
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
