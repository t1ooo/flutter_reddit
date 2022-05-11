import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_reddit_prototype/src/notifier/reddir_notifier.v4_2.dart';
import 'package:flutter_reddit_prototype/src/reddit_api/message.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../user_menu.dart';
import '../user_profile/user_profile_screen.dart';
import '../util/date_time.dart';
import '../widget/list.dart';
import '../widget/sliver_app_bar.dart';
import '../widget/space_bar.dart';
import 'messages.dart';

class MessageScreen extends StatelessWidget {
  MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<MessageNotifierQ>();
    final message = notifier.message;

    return Scaffold(
      drawer: UserMenu(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            PrimarySliverAppBar(
              elevation: 2,
              forceElevated: true,
              collapsed: true,
              flexibleSpace: SpaceBar(
                leading: AppBarBackButton(),
                title: AppBarTitle('Inbox'),
              ),
            ),
          ];
        },
        body: CustomListView(
          // shrinkWrap: true,
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
            MarkdownBody(
              data: message.body,
              onTapLink: (_, href, __) {
                if (href != null) launch(href);
              },
            ),
          ],
        ),
      ),
    );
  }
}
