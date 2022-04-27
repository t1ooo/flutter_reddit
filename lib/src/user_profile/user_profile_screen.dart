import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/widget/loader.v2.dart';

import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import 'user_profile.v1.dart';

// TODO: rename to UserProfileScreen loader
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
      body: Loader<UserNotifierQ>(
        load: (context) => context.read<UserLoaderNotifierQ>().loadUser(name),
        data: (context) => context.read<UserLoaderNotifierQ>().user,
        onData: (context, user) {
          return ChangeNotifierProvider<UserNotifierQ>.value(
            value: user,
            child: UserProfile(isCurrentUser: false),
          );
        },
      ),
    );
  }
}

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
