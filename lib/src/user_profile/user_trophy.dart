import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../reddit_api/trophy.dart';
import '../widget/network_image.dart';

class UserTrophy extends StatelessWidget {
  const UserTrophy({
    Key? key,
    required this.trophy,
  }) : super(key: key);

  final Trophy trophy;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: Image.network(trophy.icon40),
      leading: CustomNetworkImageBuilder(trophy.icon40),
      title: Text(trophy.name),
      subtitle: Text(_formatter.format(trophy.grantedAt)),
    );
  }

  static final _formatter = DateFormat('y-MM-d');
}
