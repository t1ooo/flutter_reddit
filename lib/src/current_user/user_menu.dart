import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

import '../logging.dart';
import '../notifier/auth_notifier.dart';
import '../notifier/current_user_notifier.dart';
import '../notifier/user_notifier.dart';
import '../ui_logger.dart';
import '../user_profile/user_profile_screen.dart';
import '../util/date_time.dart';
import '../widget/snackbar.dart';
import 'saved_screen.dart';

class UserMenu extends StatelessWidget {
  const UserMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<CurrentUserNotifier>();
    final user = notifier.user;

    final navigator = Navigator.of(context);
    void closeDrawer() => navigator.pop();

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
                    user.iconImg,
                    cacheManager: context.read<CacheManager>(),
                  ),
                  onForegroundImageError: (e, _) => uiLogger.error('$e'),
                ),
                Text('u/${user.name}'),
              ],
            ),
          ),
          SizedBox(height: 25),
          Table(
            children: [
              TableRow(
                children: [
                  Center(child: Text(user.totalKarma.toString())),
                  Center(child: Text(formatDateTime(user.created))),
                ],
              ),
              TableRow(
                children: const [
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
                  builder: (_) => ChangeNotifierProvider<UserNotifier>.value(
                    value: notifier,
                    child: UserProfileScreen(),
                  ),
                ),
              );
              closeDrawer();
            },
          ),
          if (kDebugMode)
            ListTile(
              minLeadingWidth: 0,
              leading: Icon(Icons.paid),
              title: Text('Reddit coins'),
              onTap: () {
                showTodoSnackBar(context); // TODO
                closeDrawer();
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
                  builder: (_) => ChangeNotifierProvider<UserNotifier>.value(
                    value: notifier,
                    child: SavedScreen(),
                  ),
                ),
              );
              closeDrawer();
            },
          ),
          if (kDebugMode)
            ListTile(
              minLeadingWidth: 0,
              leading: Icon(Icons.history),
              title: Text('History'),
              onTap: () {
                showTodoSnackBar(context); // TODO
                closeDrawer();
              },
            ),
          ListTile(
            minLeadingWidth: 0,
            leading: Icon(Icons.logout),
            title: Text('Log out'),
            onTap: () async {
              await context
                  .read<AuthNotifier>()
                  .logout()
                  .catchError((e) => showErrorSnackBar(context, e));
              closeDrawer();
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
                closeDrawer();
              },
            ),
        ],
      ),
    );
  }
}
