import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/widget/loader.dart';

import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import 'user_profile.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({
    Key? key,
    required this.name,
    // this.isCurrentUser = false,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    final notifier = context.read<UserLoaderNotifierQ>();

    return Loader<UserNotifierQ>(
      load: (_) => notifier.loadUser(name),
      data: (_) => notifier.user,
      onData: (_, user) {
        return ChangeNotifierProvider<UserNotifierQ>.value(
          value: user,
          child: UserProfile(isCurrentUser: false),
        );
      },
    );
  }
}

// TODO: move to dir current user
class CurrentUserProfileScreen extends StatelessWidget {
  const CurrentUserProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: UserProfile(isCurrentUser: true),
    );
  }
}
