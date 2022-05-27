import '../logging.dart';
import '../reddit_api/reddit_api.dart';
import 'base_notifier.dart';
import 'const.dart';
import 'subreddit_notifier.dart';

class SearchSubredditsNotifier extends BaseNotifier {
  SearchSubredditsNotifier(this._redditApi);

  final RedditApi _redditApi;

  // void reset() {
  //   _query = '';
  //   _subreddits = null;
  //   // notifyListeners();
  // }

  String _query = '';

  List<SubredditNotifier>? _subreddits;
  List<SubredditNotifier>? get subreddits => _subreddits;

  Future<void> reloadSearch() {
    _subreddits = null;
    return search(_query);
  }

  Future<void> search(String query) {
    return try_(() async {
      if (_subreddits != null && _query == query) return;
      _query = query;

      _subreddits = (await _redditApi.searchSubreddits(query, limit: limit))
          .map((v) => SubredditNotifier(_redditApi, v))
          .toList();
      notifyListeners();
    }, 'fail to search subreddits');
  }
}
