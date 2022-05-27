import 'package:flutter/material.dart';

import '../current_user/user_menu.dart';
import '../widget/sliver_app_bar.dart';
import 'home.dart';
import 'popular.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
                tabs: const [
                  Tab(text: 'Home'),
                  Tab(text: 'Popular'),
                ],
              ),
            ];
          },
          body: TabBarView(
            children: const [
              Home(),
              Popular(),
            ],
          ),
        ),
      ),
    );
  }
}
