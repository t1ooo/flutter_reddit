import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../logging/logging.dart';
import '../reddit_api/reddit_api.dart';
import '../reddit_api/trophy.dart';
import '../reddit_api/user.dart';
import 'comment_notifier.dart';
import 'limit.dart';
import 'submission_notifier.dart';
import 'subreddit_notifier.dart';
import 'try_mixin.dart';

class UserNotifier with TryMixin, ChangeNotifier {
  UserNotifier(this._redditApi, this._user)
      : _name = _user.name,
        _subreddit = SubredditNotifier(_redditApi, _user.subreddit, true);

  final RedditApi _redditApi;

  static final _log = getLogger('UserNotifier');

  final String _name;

  final SubredditNotifier _subreddit;
  SubredditNotifier get subreddit => _subreddit;

  User _user;
  User get user => _user;

  List<SubmissionNotifier>? _submissions;
  List<SubmissionNotifier>? get submissions => _submissions;

  Future<void> reloadSubmissions() {
    _submissions = null;
    return loadSubmissions();
  }

  Future<void> loadSubmissions() {
    return try_(() async {
      if (_submissions != null) return;
      _submissions = (await _redditApi.userSubmissions(_name, limit: limit))
          .map((v) => SubmissionNotifier(_redditApi, v))
          .toList();
      notifyListeners();
    }, 'fail to load user submissions');
  }

  List<CommentNotifier>? _comments;
  List<CommentNotifier>? get comments => _comments;

  Future<void> reloadComments() {
    _comments = null;
    return loadComments();
  }

  Future<void> loadComments() {
    return try_(() async {
      if (_comments != null) return;
      _comments = (await _redditApi.userComments(_name, limit: limit))
          .map((v) => CommentNotifier(_redditApi, v))
          .toList();
      notifyListeners();
    }, 'fail to load user comments');
  }

  List<Trophy>? _trophies;
  List<Trophy>? get trophies => _trophies;
  Future<void> loadTrophies() {
    return try_(() async {
      if (_trophies != null) return;
      _trophies = await _redditApi.userTrophies(_name);
      notifyListeners();
    }, 'fail to load user comments');
  }

  List<CommentNotifier>? _savedComments;
  List<CommentNotifier>? get savedComments =>
      _savedComments?.where((v) => v.comment.saved).toList();
  List<SubmissionNotifier>? _savedSubmissions;
  List<SubmissionNotifier>? get savedSubmissions =>
      _savedSubmissions?.where((v) => v.submission.saved).toList();

  Future<void> reloadSaved() {
    _savedComments = null;
    return loadSaved();
  }

  Future<void> loadSaved() {
    return try_(() async {
      if (_savedComments != null && _savedSubmissions != null) return;
      final saved = await _redditApi.userSaved(_user.name, limit: limit);
      _savedSubmissions = saved.submissions
          .map((v) => SubmissionNotifier(_redditApi, v))
          .toList();
      _savedComments =
          saved.comments.map((v) => CommentNotifier(_redditApi, v)).toList();
      notifyListeners();
    }, 'fail to load saved');
  }

  Future<void> block() {
    return _updateBlock(true);
  }

  Future<void> unblock() {
    return _updateBlock(false);
  }

  Future<void> _updateBlock(bool block) {
    return try_(() async {
      if (_user.isBlocked == block) return;
      await (block ? _redditApi.userBlock : _redditApi.userUnblock)(_user.name);
      _user = _user.copyWith(isBlocked: block);
      notifyListeners();
    }, 'fail to' + (block ? 'block' : 'unblock'));
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}
