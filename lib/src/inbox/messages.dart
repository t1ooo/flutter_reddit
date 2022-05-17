import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/widget/swipe_to_refresh.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../util/date_time.dart';
import '../widget/snackbar.dart';
import '../widget/loader.dart';
import 'message_screen.dart';

class Messages extends StatelessWidget {
  Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserAuth>().user!;

    return SwipeToRefresh(
      onRefresh: () => notifier
          .reloadInboxMessages()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: Loader<List<MessageNotifier>>(
        load: (_) => notifier.loadInboxMessages(),
        data: (_) => notifier.inboxMessages,
        onData: (_, messages) {
          return ListView(
            shrinkWrap: true,
            children: [
              for (final message in messages) ...[
                Container(
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ChangeNotifierProvider<MessageNotifier>.value(
                            value: message,
                            child: MessageScreen(),
                          ),
                        ),
                      );
                    },
                    leading: Icon(Icons.mail),
                    title: Text(message.message.subject),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.message.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'u/${message.message.author}',
                              style: TextStyle(color: Colors.red),
                            ),
                            Text(' • '),
                            Text(formatDateTime(message.message.created)),
                          ],
                        ),
                      ],
                    ),
                  ),
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
