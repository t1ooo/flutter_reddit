import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../logging/logging.dart';
import '../reddit_api/reddit_api.dart';
import 'limit.dart';
import 'subreddit_notifier.dart';
import 'try_mixin.dart';

// TODO: rename
class SearchSubredditsQ with TryMixin, ChangeNotifier {
  SearchSubredditsQ(this._redditApi);

  final RedditApi _redditApi;

  static final _log = getLogger('SearchSubreddits');

  void reset() {
    _query = '';
    _subreddits = null;
    notifyListeners();
  }

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

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}
