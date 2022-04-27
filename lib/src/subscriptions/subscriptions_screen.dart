import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import '../search/search_field.dart';
import 'subscriptions.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('SubscriptionsScreen'),
        ),
        body: Column(
          children: [
            Padding(
              padding: pagePadding,
              child: SearchField(),
            ),
            Container(
              child: TabBar(
                labelColor: Colors.blue,
                tabs: [
                  Tab(text: 'Subscriptions'),
                  Tab(text: 'Popular'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Subscriptions(),
                  Text('Custom Feed'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
