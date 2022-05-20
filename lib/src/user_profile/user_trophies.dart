import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../notifier/auth_notifier.dart';
import '../notifier/collapse_mixin.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/current_user_notifier.dart';
import '../notifier/home_front_notifier.dart';
import '../notifier/home_popular_notifier.dart';
import '../notifier/iterable_sum.dart';
import '../notifier/likable_mixin.dart';
import '../notifier/limit.dart';
import '../notifier/list_notifier.dart';
import '../notifier/message_notifier.dart';
import '../notifier/property_listener.dart';
import '../notifier/replyable.dart';
import '../notifier/reportable.dart';
import '../notifier/rule_notifier.dart';
import '../notifier/savable_mixin.dart';
import '../notifier/score.dart';
import '../notifier/search_notifier.dart';
import '../notifier/search_subreddits.dart';
import '../notifier/submission_loader_notifier.dart';
import '../notifier/submission_notifier.dart';
import '../notifier/submissions_notifier.dart';
import '../notifier/subreddit_loader_notifier.dart';
import '../notifier/subreddit_notifier.dart';
import '../notifier/try_mixin.dart';
import '../notifier/user_loader_notifier.dart';
import '../notifier/user_notifier.dart';
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
