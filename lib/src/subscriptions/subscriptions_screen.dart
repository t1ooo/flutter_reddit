import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../user_menu.dart';
import '../widget/sliver_app_bar.dart';
import 'subscriptions.dart';

class SubscriptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserMenu(),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
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
                  ),
                  title: SearchForm(),
                ),
              ),
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  width: 100,
                  child: TabBar(
                    indicatorColor: selectedColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(text: 'Subscriptions'),
                      Tab(text: 'Custom Feed'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              ChangeNotifierProvider<CurrentUserNotifier>.value(
                value: context.read<UserAuth>().user!,
                child: Subscriptions(),
              ),
              Text('TODO'),
            ],
          ),
        ),
      ),
    );
  }
}
