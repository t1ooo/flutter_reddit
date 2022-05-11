import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../util/date_time.dart';
import '../widget/loader.dart';
import 'message_screen.dart';

class Messages extends StatelessWidget {
  Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserAuth>().user!;

    return Loader<List<MessageNotifierQ>>(
      load: (_) => notifier.loadInboxMessages(),
      data: (_) => notifier.inboxMessages,
      onData: (_, messages) {
        return ListView(
          shrinkWrap: true,
          children: [
            for (final message in messages) ...[
              Container(
                // decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ChangeNotifierProvider<MessageNotifierQ>.value(
                          value: message,
                          child: MessageScreen(),
                        ),
                      ),
                    );
                  },
                  leading: Icon(Icons.mail),
                  title: Text(message.message.subject),
                  // subtitle: Text(message.message.desc),
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
            // InkWell(
            //   onTap: message.message.submissionId == ''
            //       ? null
            //       : () {
            //           // Navigator.push(
            //           //   context,
            //           //   MaterialPageRoute(
            //           //     builder: (_) =>
            //           //         SubmissionScreen(id: message.submissionId),
            //           //   ),
            //           // );
            //         },
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //     // padding: commentPadding(0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(message.message.linkTitle, textScaleFactor: 2),
            //         Row(
            //           children: [
            //             Text(message.message.subredditNamePrefixed),
            //             Text(' • '),
            //             Text(message.message.created.toString()),
            //             Text(' • '),
            //             Text(message.message.ups.toString()),
            //           ],
            //         ),
            //         SizedBox(height: 10),
            //         Text(message.message.body),
            //         // Text(message.message.isSubmitter.toString()),
            //         Divider(),
            //       ],
            //     ),
            //   ),
            // )
          ],
        );
      },
    );
  }
}
