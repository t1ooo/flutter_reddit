import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import 'saved_comments.dart';
import 'saved_submissions.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('SavedScreen'),
        ),
        body: Column(
          children: [
            SizedBox(height: topPadding),
            Container(
              child: TabBar(
                labelColor: Colors.blue,
                tabs: [
                  Tab(child: Text('Posts')),
                  Tab(child: Text('Comments')),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SavedSubmissions(),
                  SavedComments(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
