import '../reddit_api/reddit_api.dart';
import '../reddit_api/user.dart';
import 'const.dart';
import 'message_notifier.dart';
import 'subreddit_notifier.dart';
import 'user_notifier.dart';

class CurrentUserNotifier extends UserNotifier {
  CurrentUserNotifier(this._redditApi, User user) : super(_redditApi, user);

  final RedditApi _redditApi;

  // SubredditNotifier? _all;
  // SubredditNotifier? get all => _all;

  List<SubredditNotifier>? _subreddits;
  List<SubredditNotifier>? get subreddits => _subreddits;

  Future<void> reloadSubreddits() {
    // _all = null;
    _subreddits = null;
    return loadSubreddits();
  }

  Future<void> loadSubreddits() {
    return try_(() async {
      // await _loadSubredditAll();
      // await _loadSubreddits();
      if (_subreddits != null) return;

      _subreddits = (await _redditApi.currentUserSubreddits(limit: limit))
          .map((v) => _addListener(SubredditNotifier(_redditApi, v)))
          .toList();
      _subreddits!
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    }, 'fail to load subreddits');
  }

  // Future<void> _loadSubredditAll() async {
  //   if (_all != null) {
  //     return;
  //   }
  //   _all = _addListener(
  //       SubredditNotifier(_redditApi, await _redditApi.subreddit('all')));
  //   notifyListeners();
  // }

  // Future<void> _loadSubreddits() async {
  //   if (_subreddits != null) {
  //     return;
  //   }
  //   _subreddits = (await _redditApi.currentUserSubreddits(limit: limit))
  //       .map((v) => _addListener(SubredditNotifier(_redditApi, v)))
  //       .toList();
  //   notifyListeners();
  // }

  SubredditNotifier _addListener(SubredditNotifier t) {
    return t
      ..addPropertyListener<bool>(() => t.subreddit.userHasFavorited, () {
        notifyListeners();
      });
  }

  List<MessageNotifier>? _inboxMessages;
  List<MessageNotifier>? get inboxMessages => _inboxMessages;

  Future<void> reloadInboxMessages() {
    _inboxMessages = null;
    return loadInboxMessages();
  }

  Future<void> loadInboxMessages() {
    return try_(() async {
      if (_inboxMessages != null) {
        return;
      }
      _inboxMessages = (await _redditApi.inboxMessages())
          .map((v) => MessageNotifier(_redditApi, v))
          .toList();
      notifyListeners();
    }, 'fail to load inbox messages');
  }
}
