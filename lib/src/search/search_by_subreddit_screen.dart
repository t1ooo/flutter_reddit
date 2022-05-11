import 'package:flutter/material.dart';

import '../style/style.dart';
import '../widget/sliver_app_bar.dart';
import '../widget/space_bar.dart';
import 'search_posts.dart';
import 'search_subreddits.dart';
// import 'search_field.dart';

class SearchBySubredditScreen extends StatelessWidget {
  SearchBySubredditScreen({
    Key? key,
    required this.query,
    required this.subreddit,
  }) : super(key: key);

  final String query;
  final String subreddit;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            // print(innerBoxIsScrolled);
            return [
              PrimarySliverAppBar(
                collapsed: true,
                flexibleSpace: SpaceBar(
                  leading: AppBarBackButton(),
                  // leading: AppBarBackButton.black(),
                  title: SearchForm(query: query, subreddit: subreddit),
                ),
              ),
              SliverAppBar(
                toolbarHeight: 120,
                pinned: true,
                automaticallyImplyLeading: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ListTile(
                    minLeadingWidth: 0,
                    title: Text(query),
                    subtitle: Text('Search results by $subreddit'),
                  ),
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //   Text(query),
                //   Text('Search results'),
                // ],)
              ),
            ];
          },
          // body: Expanded(child: Search(query: query)),
          body: SearchPosts(query: query, subreddit: subreddit),
        ),
      ),
    );
  }
}
