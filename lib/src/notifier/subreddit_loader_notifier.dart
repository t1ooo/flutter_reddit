import '../reddit_api/reddit_api.dart';
import 'base_notifier.dart';
import 'subreddit_notifier.dart';

class SubredditLoaderNotifier extends BaseNotifier {
  SubredditLoaderNotifier(this._redditApi);

  final RedditApi _redditApi;

  // void reset() {
  //   _name = null;
  //   _subreddit = null;
  //   // notifyListeners();
  // }

  String? _name;

  SubredditNotifier? _subreddit;
  SubredditNotifier? get subreddit => _subreddit;

  Future<void> loadSubreddit(String name) {
    return try_(
      () async {
        if (_subreddit != null && _name == name) return;
        _name = name;

        _subreddit =
            SubredditNotifier(_redditApi, await _redditApi.subreddit(_name!));
        notifyListeners();
      },
      'fail to load subreddit',
    );
  }
}
