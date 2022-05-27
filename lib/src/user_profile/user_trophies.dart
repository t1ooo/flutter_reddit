import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../notifier/user_notifier.dart';
import '../reddit_api/trophy.dart';
import '../style.dart';
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
        return PrimaryColorListView(
          children: [
            ListTitle('trophies'),
            SizedBox(height: 10),
            Container(
              color: primaryColor,
              child: CustomListView(
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
