import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/notifier/reddir_notifier.v4_2.dart';
import 'package:flutter_reddit_prototype/src/user_profile/user_trophies.dart';
import 'package:provider/provider.dart';

import '../style/style.dart';
import '../util/date_time.dart';
// import '../widget/stream_list_builder.dart';

class UserAbout extends StatelessWidget {
  const UserAbout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserNotifierQ>().user;
    return Container(
      // padding: pagePadding,
      color: Theme.of(context).primaryColor,

      child: ListView(
        shrinkWrap: true,
        children: [
          // SizedBox(height: 10),
          Container(
            // height: 40,
            color: Theme.of(context).scaffoldBackgroundColor,
            height: 10,
          ),
          Container(
            // color: Theme.of(context).primaryColor,
            // elevation: 0,
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: 50),
                Table(
                  children: [
                    TableRow(
                      children: [
                        Center(child: Text(user.totalKarma.toString())),
                        Center(child: Text(formatDateTime(user.created))),
                      ],
                    ),
                    TableRow(
                      children: [
                        Center(child: Text('Karma')),
                        Center(child: Text('Reddit age')),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 50),
                ListTile(
                    leading: Icon(Icons.mail), title: Text('Send a message')),
                ListTile(leading: Icon(Icons.chat), title: Text('Start chat')),
              ],
            ),
          ),
          UserTrophies(),
        ],
      ),
    );
  }
}
