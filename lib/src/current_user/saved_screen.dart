import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style.dart';

import '../widget/sliver_app_bar.dart';
import 'saved_comments.dart';
import 'saved_submissions.dart';

class SavedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              PrimarySliverAppBar(
                flexibleSpace: SpaceBar(
                  leading: AppBarBackButton(),
                  title: AppBarTitle('Saved'),
                ),
              ),
              SliverTabBar(
                tabs: [
                  Tab(child: Text('Posts')),
                  Tab(child: Text('Comments')),
                ],
              ),
            ];
          },
          body: TabBarView(
            children: [
              SavedSubmissions(),
              SavedComments(),
            ],
          ),
        ),
      ),
    );
  }
}
