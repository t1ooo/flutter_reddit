import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/user_profile/user_comment.dart';
import 'package:flutter_reddit_prototype/src/user_profile/user_trophies.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import '../reddit_api/user.dart';
import '../reddit_api/comment.dart';
import '../style/style.dart';
import '../util/date_time.dart';
import '../widget/stream_list_builder.dart';

class UserAbout extends StatelessWidget {
  const UserAbout({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    // return GridView.count(
    //   crossAxisCount: 2,
    //   childAspectRatio: 6/3,
    //   children: [
    //     Center(child: Text('Item')),
    //     Center(child: Text('Item')),
    //   ],
    // );
    // return Column(
    //   children: [
    //     Row(
    //       children: [
    //         Column(
    //           children: [
    //             Text(user.totalKarma.toString()),
    //             Text('Karma'),
    //           ],
    //         ),
    //         Spacer(),
    //         Column(
    //           children: [
    //             Text(formatDateTime(user.created)),
    //             Text('Reddit age'),
    //           ],
    //         ),
    //       ],
    //     ),

    //   ],
    // );

    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50),
        Table(
          // defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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

        ListTile(leading: Icon(Icons.mail), title: Text('Send a message')),
        ListTile(leading: Icon(Icons.chat), title: Text('Start chat')),
        UserTrophies(user: user),
      ],
    );
  }
}
