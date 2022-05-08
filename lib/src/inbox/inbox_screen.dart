import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/reddit_api/message.dart';

import '../user_menu.dart';
import '../widget/sliver_app_bar.dart';
import '../widget/space_bar.dart';
import 'messages.dart';

class InboxScreen extends StatelessWidget {
  InboxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserMenu(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            PrimarySliverAppBar(
              collapsed: true,
              flexibleSpace: SpaceBar(
                leading: IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: SpaceBarIcon(Icons.account_circle),
                  // iconData: Icons.account_circle,
                  // theme: appBarIconThemeDark,
                ),
                title: AppBarTitle('Inbox'),
              ),
            ),
          ];
        },
        body: Messages(),
      ),
    );
  }
}
