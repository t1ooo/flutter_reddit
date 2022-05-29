import 'package:flutter/material.dart';

import '../widget/sliver_app_bar.dart';
import 'search_posts.dart';
import 'search_subreddits.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({
    Key? key,
    required this.query,
  }) : super(key: key);

  final String query;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              PrimarySliverAppBar(
                collapsed: true,
                flexibleSpace: SpaceBar(
                  leading: AppBarBackButton(),
                  title: SearchForm(query: query),
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
                    subtitle: Text('Search results'),
                  ),
                ),
              ),
              SliverTabBar(
                tabBar: TabBar(
                  tabs: const [
                    Tab(text: 'Posts'),
                    Tab(text: 'Subreddits'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              SearchPosts(query: query),
              SearchSubreddits(query: query),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBySubredditScreen extends StatelessWidget {
  const SearchBySubredditScreen({
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
          headerSliverBuilder: (context, _) {
            return [
              PrimarySliverAppBar(
                collapsed: true,
                flexibleSpace: SpaceBar(
                  leading: AppBarBackButton(),
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
              ),
            ];
          },
          body: SearchPosts(query: query, subreddit: subreddit),
        ),
      ),
    );
  }
}
