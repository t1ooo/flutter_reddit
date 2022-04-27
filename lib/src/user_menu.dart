import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/user_profile/user_profile_screen.dart';
import 'package:flutter_reddit_prototype/src/util/snackbar.dart';
import 'package:provider/provider.dart';

import 'current_user/saved_screen.dart';
// import 'notifier/reddir_notifier.dart';
import 'notifier/reddir_notifier.v4_2.dart';
import 'reddit_api/user.dart';
import 'util/date_time.dart';

class UserMenu extends StatelessWidget {
  UserMenu({
    Key? key,
    // required this.user,
    // required this.totalAwardsReceived,
  }) : super(key: key);

  // final User? user;
  // final int totalAwardsReceived;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<UserAuth>();

    final user = notifier.user;
    if (user == null) {
      return anonymousUserMenu(context, notifier);
    }
    return userMenu(context, user);
  }

  Widget anonymousUserMenu(BuildContext context, UserAuth notifier) {
    return Drawer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 80),
                ),
                Text('anonymous'),
              ],
            ),
          ),
          ListTile(
            minLeadingWidth: 0,
            leading: Icon(Icons.login),
            title: Text('Sign up/ Log in'),
            onTap: () {
              // final result = await notifier.login('name', 'password');
              // if (result != null) {
              //   showSnackBar(context, result);
              // }
              notifier
                  .login('name', 'password')
                  .catchError((e) => showErrorSnackBar(context, e));
              // Navigator.pop(context);
            },
          ),
          // Expanded(child: Container()),
          Spacer(),
          ListTile(
            minLeadingWidth: 0,
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget userMenu(BuildContext context, CurrentUserNotifierQ user) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Column(
        // child: ListView(
        // padding: EdgeInsets.zero,
        children: [
          // DrawerHeader(
          //   // margin: EdgeInsets.zero,
          //   // padding: EdgeInsets.zero,
          //   // decoration: BoxDecoration(
          //   //   color: Colors.blue,
          //   // ),
          //   child: Column(
          //     children: [
          //       CircleAvatar(
          //         radius: 50,
          //         backgroundImage: NetworkImage(''),
          //       ),
          //       Text('u/graibn'),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user.user.iconImg),
                ),
                Text(user.user.subreddit.displayNamePrefixed),
              ],
            ),
          ),
          SizedBox(height: 25),

          Table(
            // defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // builder: (_) => UserProfileScreenV2(
                  //   user: user.user,
                  //   isCurrentUser: true,
                  // ),
                  builder: (_) {
                    // return CurrentUserProfileScreen(
                    // name: user.user.name,
                    // isCurrentUser: true,
                    // );
                    return ChangeNotifierProvider<UserNotifierQ>.value(
                      value: user,
                      child: CurrentUserProfileScreen(),
                    );
                  },
                ),
              );
              // Navigator.pop(context);
            },
          ),
          ListTile(
            minLeadingWidth: 0,
            leading: Icon(Icons.paid),
            title: Text('Reddit coins'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            minLeadingWidth: 0,
            leading: Icon(Icons.bookmark),
            title: Text('Saved'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SavedScreen(),
                ),
              );
              // Navigator.pop(context);
            },
          ),
          ListTile(
            minLeadingWidth: 0,
            leading: Icon(Icons.history),
            title: Text('History'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            minLeadingWidth: 0,
            leading: Icon(Icons.logout),
            title: Text('Log out'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Spacer(),
          // Expanded(child: Container()),
          ListTile(
            minLeadingWidth: 0,
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          // Expanded(
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Text('Bottom'),
          //   ),
          // ),
        ],
      ),
    );
  }
}
