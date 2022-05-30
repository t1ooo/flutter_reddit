import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/search_subreddits_notifier.dart';
import '../notifier/subreddit_notifier.dart';
import '../style.dart';
import '../widget/list.dart';
import '../widget/loader.dart';
import '../widget/pull_to_refresh.dart';
import '../widget/snackbar.dart';
import 'search_subreddit.dart';

class SearchSubreddits extends StatelessWidget {
  const SearchSubreddits({
    Key? key,
    required this.query,
  }) : super(key: key);

  final String query;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SearchSubredditsNotifier>();

    return PullToRefresh(
      onRefresh: () => notifier
          .reloadSearch()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: Loader<List<SubredditNotifier>>(
        load: (_) => notifier.search(query),
        data: (_) => notifier.subreddits,
        onData: (_, subreddits) {
          return Container(
            color: primaryColor,
            child: CustomListView(
              key: PageStorageKey(runtimeType.toString()),
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
