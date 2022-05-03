import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../style/style.dart';
import '../util/date_time.dart';
import '../widget/network_image.dart';
import '../widget/subscribe_button.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserNotifierQ>();
    final user = notifier.user;

    return Container(
      color: Theme.of(context).primaryColor,
      padding: pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: topPadding),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    // child: Image.network(user.iconImg),
                    child: CustomNetworkImageBuilder(user.iconImg),
                  ),
                ],
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, textScaleFactor: 2),
                  Text(user.subreddit.displayNamePrefixed),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          if (notifier.isCurrentUser)
            ElevatedButton(onPressed: () {}, child: Text('EDIT'))
          else
            Row(
              // alignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(onPressed: () {}, child: Text('CHAT')),
                SizedBox(width: 10),
                ChangeNotifierProvider<SubredditNotifierQ>.value(
                  value: notifier.subreddit,
                  child: SubscribeButton(isUserPage: true),
                ),
              ],
            ),
          SizedBox(height: 20),
          Text(
              '${user.totalKarma} karma • ${formatDateTime(user.created)} • ${'${user.subreddit.subscribers} followers'}'),
          SizedBox(height: 10),
          Text(user.subreddit.publicDescription),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
