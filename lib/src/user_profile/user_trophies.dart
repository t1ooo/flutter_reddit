import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/trophy.dart';
import '../widget/list.dart';
import '../widget/loader.dart';
import 'user_trophy.dart';

class UserTrophies extends StatelessWidget {
  const UserTrophies({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserNotifier>();

    return Loader<List<Trophy>>(
      load: (_) => notifier.loadTrophies(),
      data: (_) => notifier.trophies,
      onData: (_, trophies) {
        return CustomListView(
          children: [
            ListTitle('trophies'),
            Container(
              color: Theme.of(context).primaryColor,
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final trophy in trophies) UserTrophy(trophy: trophy),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
