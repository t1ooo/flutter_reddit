import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/current_user_notifier.dart';
import '../notifier/message_notifier.dart';
import '../widget/list.dart';
import '../widget/loader.dart';
import '../widget/snackbar.dart';
import '../widget/swipe_to_refresh.dart';
import 'message_tile.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<CurrentUserNotifier>();

    return SwipeToRefresh(
      onRefresh: () => notifier
          .reloadInboxMessages()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: Loader<List<MessageNotifier>>(
        load: (_) => notifier.loadInboxMessages(),
        data: (_) => notifier.inboxMessages,
        onData: (_, messages) {
          return CustomListView(
            shrinkWrap: true,
            children: [
              for (final message in messages) ...[
                ChangeNotifierProvider<MessageNotifier>.value(
                  value: message,
                  child: MessageTile(),
                ),
                Divider(height: 0),
              ],
            ],
          );
        },
      ),
    );
  }
}
