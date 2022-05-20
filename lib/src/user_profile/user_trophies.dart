import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/trophy.dart';
import '../widget/list.dart';
import '../widget/loader.dart';
import '../widget/network_image.dart';
import '../widget/snackbar.dart';

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
            SizedBox(height: 10),
            Container(
              color: Theme.of(context).primaryColor,
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final trophy in trophies) _userTrophy(context, trophy),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _userTrophy(BuildContext context, Trophy trophy) {
    return ListTile(
      onTap: () {
        showTodoSnackBar(context); // TODO
      },
      leading: SizedBox.square(
        dimension: 40,
        child: CustomNetworkImageBuilder(trophy.icon40),
      ),
      title: Text(trophy.name),
      subtitle: Text(_formatter.format(trophy.grantedAt)),
    );
  }

  static final _formatter = DateFormat('y-MM-d');
}
