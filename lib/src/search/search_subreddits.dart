
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../widget/snackbar.dart';
import '../widget/loader.dart';
import '../widget/swipe_to_refresh.dart';
import 'search_subreddit.dart';

class SearchSubreddits extends StatelessWidget {
  const SearchSubreddits({
    Key? key,
    required this.query,
  }) : super(key: key);

  final String query;

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<SearchSubredditsQ>();

    return SwipeToRefresh(
      onRefresh: () => notifier
          .reloadSearch()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: Loader<List<SubredditNotifier>>(
        load: (_) => notifier.search(query),
        data: (_) => notifier.subreddits,
        onData: (_, subreddits) {
          return Container(
            color: Theme.of(context).primaryColor,
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final subreddit in subreddits)
                  ChangeNotifierProvider<SubredditNotifier>.value(
                    value: subreddit,
                    child: SearchSubreddit(),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

 
 
 
 
 
 
 
 
 
 

 
 
 
 
 
 
 
 
 
 
}
