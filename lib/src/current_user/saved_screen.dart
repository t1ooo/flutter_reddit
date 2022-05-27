import 'package:flutter/material.dart';

import '../widget/sliver_app_bar.dart';
import 'saved_comments.dart';
import 'saved_submissions.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({Key? key}) : super(key: key);

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
                tabs: const [
                  Tab(child: Text('Posts')),
                  Tab(child: Text('Comments')),
                ],
              ),
            ];
          },
          body: TabBarView(
            children: const [
              SavedSubmissions(),
              SavedComments(),
            ],
          ),
        ),
      ),
    );
  }
}
