import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../const.dart';
import '../notifier/message_notifier.dart';
import '../style.dart';
import '../user_profile/user_profile_screen.dart';
import '../util/date_time.dart';
import '../widget/list.dart';
import '../widget/markdown.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<MessageNotifier>();
    final message = notifier.message;

    return PrimaryColorListView(
      padding: pagePadding,
      children: [
        SizedBox(height: 20),
        Text(
          message.subject,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Divider(),
        Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserProfileScreen(name: message.author),
                  ),
                );
              },
              child: Text(
                'u/${message.author}',
                style: TextStyle(color: Colors.red),
              ),
            ),
            Text(' • '),
            Text(formatDateTime(message.created)),
          ],
        ),
        SizedBox(height: 10),
        Markdown(message.body, baseUrl: redditBaseUrl),
      ],
    );
  }
}
