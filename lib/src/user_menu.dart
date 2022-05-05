import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_reddit_prototype/src/util/snackbar.dart';
import 'package:provider/provider.dart';

import 'current_user/saved_screen.dart';
import 'notifier/reddir_notifier.v4_2.dart';
import 'current_user/current_user_profile_screen.dart';
import 'util/date_time.dart';

class UserMenu extends StatelessWidget {
  UserMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<UserAuth>();
    final user = notifier.user!;
    return Drawer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  foregroundImage: CachedNetworkImageProvider(
                    user.user.iconImg,
                    cacheManager: context.read<CacheManager>(),
                  ),
                  onForegroundImageError: (e, _) => log('$e'),
                ),
                Text(user.user.subreddit.displayNamePrefixed),
              ],
            ),
          ),
          SizedBox(height: 25),
          Table(
            children: [
              TableRow(
                children: [
                  Center(child: Text(user.user.totalKarma.toString())),
                  Center(child: Text(formatDateTime(user.user.created))),
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
          SizedBox(height: 25),
          ListTile(
            minLeadingWidth: 0,
            leading: Icon(Icons.account_circle),
            title: Text('My profile'),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return ChangeNotifierProvider<UserNotifierQ>.value(
                      value: user,
                      child: CurrentUserProfileScreen(),
                    );
                  },
                ),
              );
              Navigator.pop(context);
            },
          ),
          if (kDebugMode)
            ListTile(
              minLeadingWidth: 0,
              leading: Icon(Icons.paid),
              title: Text('Reddit coins'),
              onTap: () {
                showTodoSnackBar(context); // TODO
                Navigator.pop(context);
              },
            ),
          ListTile(
            minLeadingWidth: 0,
            leading: Icon(Icons.bookmark),
            title: Text('Saved'),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider<UserNotifierQ>.value(
                    value: user,
                    child: SavedScreen(),
                  ),
                ),
              );
              Navigator.pop(context);
            },
          ),
          if (kDebugMode)
            ListTile(
              minLeadingWidth: 0,
              leading: Icon(Icons.history),
              title: Text('History'),
              onTap: () {
                showTodoSnackBar(context); // TODO
                Navigator.pop(context);
              },
            ),
          ListTile(
            minLeadingWidth: 0,
            leading: Icon(Icons.logout),
            title: Text('Log out'),
            onTap: () async {
              await notifier
                  .logout()
                  .catchError((e) => showErrorSnackBar(context, e));
              Navigator.pop(context);
            },
          ),
          Spacer(),
          if (kDebugMode)
            ListTile(
              minLeadingWidth: 0,
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                showTodoSnackBar(context); // TODO
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}
