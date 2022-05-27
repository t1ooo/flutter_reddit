import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/message_notifier.dart';
import '../util/date_time.dart';
import 'message_screen.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<MessageNotifier>();
    final message = notifier.message;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<MessageNotifier>.value(
              value: notifier,
              child: MessageScreen(),
            ),
          ),
        );
      },
      leading: Icon(Icons.mail),
      title: Text(message.subject),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Text(
                'u/${message.author}',
                style: TextStyle(color: Colors.red),
              ),
              Text(' • '),
              Text(formatDateTime(message.created)),
            ],
          ),
        ],
      ),
    );
  }
}
