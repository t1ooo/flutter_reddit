import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import '../search/search_field.dart';
import '../widget/sized_placeholder.dart';
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
            // Padding(
            //   // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            //   padding: pagePadding,
            //   child: SearchField(),
            // ),
            SizedBox(height: topPadding),
            Container(
              child: TabBar(
                // padding: EdgeInsets.symmetric(vertical :50),
                labelColor: Colors.blue,
                tabs: [
                  // Text('Posts'),
                  // Text('Comments'),
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
