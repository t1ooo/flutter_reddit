import 'package:flutter/material.dart';

import '../current_user/user_menu.dart';
import '../widget/sliver_app_bar.dart';
import 'message.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

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
                leading: AppBarBackButton(),
                title: AppBarTitle('Inbox'),
              ),
            ),
          ];
        },
        body: MessageWidget(),
      ),
    );
  }
}
