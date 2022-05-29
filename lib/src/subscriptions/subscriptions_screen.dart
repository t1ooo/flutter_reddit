import 'package:flutter/material.dart';

import '../current_user/user_menu.dart';
import '../style.dart';
import '../widget/sliver_app_bar.dart';
import 'subscriptions.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserMenu(),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              PrimarySliverAppBar(
                collapsed: true,
                flexibleSpace: SpaceBar(
                  leading: AppBarAccountButton(),
                  title: SearchForm(),
                ),
              ),
              SliverTabBar(
                tabBar: TabBar(
                  tabs: const [
                    Tab(text: 'Subscriptions'),
                    Tab(text: 'Custom Feed'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: const [
              Subscriptions(),
              Card(
                child: Padding(
                  padding: cardPadding,
                  child: Text('TODO'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
