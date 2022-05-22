import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style.dart';

import '../current_user/user_menu.dart';
import '../widget/sliver_app_bar.dart';
import 'home.dart';
import 'popular.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserMenu(),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          floatHeaderSlivers: true,
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
                tabs: [
                  Tab(text: 'Home'),
                  Tab(text: 'Popular'),
                ],
              ),
            ];
          },
          body: TabBarView(
            children: [
              Home(),
              Popular(),
            ],
          ),
        ),
      ),
    );
  }
}
