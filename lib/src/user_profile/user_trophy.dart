import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/user_profile/user_comment.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import '../reddit_api/trophy.dart';
import '../reddit_api/user.dart';
import '../reddit_api/comment.dart';
import '../style/style.dart';
import '../util/date_time.dart';
import '../widget/custom_future_builder.dart';
import '../widget/stream_list_builder.dart';

class UserTrophy extends StatelessWidget {
  const UserTrophy({
    Key? key,
    required this.trophy,
  }) : super(key: key);

  final Trophy trophy;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(trophy.icon40),
      title: Text(trophy.name),
      subtitle: Text(_formatter.format(trophy.grantedAt)),
    );
  }

  static final _formatter = DateFormat('y-MM-d');
}
