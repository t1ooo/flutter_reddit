import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/widget/loader.dart';

import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import 'user_profile.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  Widget body(BuildContext context) {
    final notifier = context.read<UserLoaderNotifier>();

    return Loader<UserNotifier>(
      load: (_) => notifier.loadUser(name),
      data: (_) => notifier.user,
      onData: (_, user) {
        return ChangeNotifierProvider<UserNotifier>.value(
          value: user,
          child: UserProfile(),
        );
      },
    );
  }
}
