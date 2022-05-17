import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import '../user_menu.dart';
import '../widget/sliver_app_bar.dart';
import 'home.dart';
import 'popular.dart';

class HomeScreenV4 extends StatelessWidget {
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
                  leading: IconButton(
                    onPressed: Scaffold.of(context).openDrawer,
                    icon: SpaceBarIcon(Icons.account_circle),
                  ),
                  title: SearchForm(),
                ),
              ),
              SliverAppBar(
                floating: true,
                primary: false,
                automaticallyImplyLeading: false,
                flexibleSpace: TabBar(
                  // indicatorColor: selectedColor, // TODO: config with app theme
                  // indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(text: 'Home'),
                    Tab(text: 'Popular'),
                  ],
                ),
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
