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
    final notifier = context.read<UserNotifierQ>();

    return Loader<List<Trophy>>(
      load: (_) => notifier.loadTrophies(),
      data: (_) => notifier.trophies,
      onData: (_, trophies) {
        return ListView(
          shrinkWrap: true,
          children: [
            // ListTile(title: Text('TROPHIES')),
            Container(
                // height: 40,
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  'TROPHIES',
                  style: Theme.of(context).textTheme.headline6,
                )),
            Container(
              color: Theme.of(context).primaryColor,
              // height: double.infinity,
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
