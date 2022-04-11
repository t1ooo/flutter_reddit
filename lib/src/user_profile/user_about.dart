import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/user_profile/user_comment.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import '../reddit_api/User.dart';
import '../reddit_api/comment.dart';
import '../style/style.dart';
import '../widget/stream_list_builder.dart';

class UserAbout extends StatelessWidget {
  const UserAbout({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Column(
            children: [
              Text(user.totalKarma.toString()),
              Text('Karma'),
            ],
          ),
           Column(
            children: [
              Text(user.created.toString()),
              Text('Reddit age'),
            ],
          ),
        ],
      ),
    ],);
  }
}
