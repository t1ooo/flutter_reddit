import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../logging/logging.dart';
import '../reddit_api/reddit_api.dart';
import 'subreddit_notifier.dart';
import 'try_mixin.dart';

class SubredditLoaderNotifier  with TryMixin, ChangeNotifier {
  SubredditLoaderNotifier(this._redditApi);

  final RedditApi _redditApi;
  static final _log = getLogger('SubredditNotifier');

  void reset() {
    _name = null;
    _subreddit = null;
    notifyListeners();
  }

  String? _name;

  SubredditNotifier? _subreddit;
  SubredditNotifier? get subreddit => _subreddit;

  Future<void> loadSubreddit(String name) {
    return try_(() async {
      if (_subreddit != null && _name == name) return;
      _name = name;

      _subreddit =
          SubredditNotifier(_redditApi, await _redditApi.subreddit(_name!));
      notifyListeners();
    }, 'fail to load subreddit');
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}
