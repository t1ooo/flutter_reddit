import 'package:flutter/material.dart';

import '../current_user/user_menu.dart';
import '../widget/sliver_app_bar.dart';
import 'messages.dart';

class InboxScreen extends StatelessWidget {
  InboxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserMenu(),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            PrimarySliverAppBar(
              collapsed: true,
              flexibleSpace: SpaceBar(
                leading: IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: SpaceBarIcon(Icons.account_circle),
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
