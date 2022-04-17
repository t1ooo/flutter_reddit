import 'package:draw/draw.dart' as draw;
import 'package:flutter/foundation.dart';

import '../logging/logging.dart';
import '../reddit_api/trophy.dart';
import '../reddit_api/user.dart';
import '../reddit_api/comment.dart';
import '../reddit_api/reddir_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import '../reddit_api/subreddit.dart';
import '../reddit_api/vote.dart';

// class RedditNotifier extends ChangeNotifier {
//   RedditNotifier(this.redditApi);

//   final RedditApi redditApi;
//   List<Submission>? _frontBest;
//   List<Submission>? _popular;
//   List<Subreddit>? _userSubreddits;

//   List<Submission>? get popular => _popular;
//   List<Submission>? get front => _frontBest;
//   List<Subreddit>? get userSubreddits => _userSubreddits;

//   Future<void> loadFrontBest({int limit = 10}) async {
//     _frontBest = await redditApi.front(limit: limit);
//     notifyListeners();
//   }

//   Future<void> loadPopular({int limit = 10}) async {
//     _popular = await redditApi.popular(limit: limit);
//     notifyListeners();
//   }

//   Future<void> loadUserSubreddits({int limit = 10}) async {
//     _userSubreddits = await redditApi.userSubreddits(limit: limit)
//       ..sort((a, b) => a.displayName.compareTo(b.displayName));
//     notifyListeners();
//   }
// }

mixin Error {
  Object? _error;

  Object? get error {
    final tmp = _error;
    _error = null;
    return tmp;
  }
}

mixin Loading {
  bool _isLoading = false;

  bool get isLoading => _isLoading;
}

class RedditNotifier extends ChangeNotifier {
  RedditNotifier(this.redditApi);

  final RedditApi redditApi;

  // TODO: rename to front
  Stream<Submission> front({int limit = 10, SubType type = SubType.best}) {
    return redditApi.front(limit: limit, type: type);
  }

  Stream<Submission> popular({int limit = 10, SubType type = SubType.best}) {
    return redditApi.popular(limit: limit, type: type);
  }

  Stream<Subreddit> userSubreddits({int limit = 10}) {
    return redditApi.userSubreddits(limit: limit);
    // ..sort((a, b) => a.displayName.compareTo(b.displayName));
  }

  Stream<Submission> subredditSubmissions(
    String name, {
    int limit = 10,
    SubType type = SubType.best,
  }) {
    return redditApi.subredditSubmissions(name, limit: limit, type: type);
  }

  Future<User> user(String name) {
    return redditApi.user(name);
  }

  Stream<Comment> userComments(String name, {int limit = 10}) {
    return redditApi.userComments(name, limit: limit);
  }

  Stream<Submission> userSubmissions(String name, {int limit = 10}) {
    return redditApi.userSubmissions(name, limit: limit);
  }

  Future<List<Trophy>> userTrophies(String name) {
    return redditApi.userTrophies(name);
  }

  Future<Submission> submission(String id) async {
    return redditApi.submission(id);
  }

  Future<Subreddit> subreddit(String name) async {
    return redditApi.subreddit(name);
  }

  Future<void> submissionVote(String id, Vote vote) async {
    return redditApi.submissionVote(id, vote);
  }

  Future<void> submissionSave(String id) async {
    return redditApi.submissionSave(id);
  }

  Future<void> submissionUnsave(String id) async {
    return redditApi.submissionUnsave(id);
  }

  Future<void> commentSave(String id) async {
    return redditApi.commentSave(id);
  }

  Future<void> commentUnsave(String id) async {
    return redditApi.commentUnsave(id);
  }

  // Future<User?> currentUser() async {
  //   return redditApi.currentUser();
  // }

  Stream<Submission> currentUserSavedSubmissions({int limit = 10}) {
    return redditApi.currentUserSavedSubmissions(limit:limit);
  }

  Stream<Comment> currentUserSavedComments({int limit = 10}) {
    return redditApi.currentUserSavedComments(limit:limit);
  }

  Future<String> subredditIcon(String name) {
    return redditApi.subredditIcon(name);
  }

  Stream<Submission> search(String query, {int limit=10, Sort sort = Sort.relevance}) {
    return redditApi.search(query, limit:limit, sort:sort);
  }
}

class CurrentUserNotifier extends ChangeNotifier with Error {
  CurrentUserNotifier(this.redditApi);

  final RedditApi redditApi;
  static final _log = Logger('CurrentUserNotifier');

  User? _user;
  User? get user => _user;

  Future<void> login(String name, String password) async {
    // _user = await redditApi.currentUser();
    try {
      final user = await redditApi.currentUser();
      if (user == null) {
        throw Exception('fail to login');
      }
      _user = user;
    } catch (e) {
      _log.error(e);
      _error = e;
    }
    notifyListeners();
  }

  Future<void> logout(String name, String password) async {
    _user = null;
    notifyListeners();
  }
}

class SubTypeNotifier extends ChangeNotifier {
  SubTypeNotifier([SubType type = SubType.best]) : _type = type;

  SubType _type = SubType.best;

  SubType get type => _type;

  set type(SubType type) {
    if (_type == type) return;

    _type = type;
    notifyListeners();
  }
}

class SortNotifier extends ChangeNotifier {
  SortNotifier([Sort type = Sort.relevance]) : _type = type;

  Sort _type = Sort.relevance;

  Sort get type => _type;

  set type(Sort type) {
    if (_type == type) return;

    _type = type;
    notifyListeners();
  }
}

// class FilterNotifier<T> extends ChangeNotifier {
//   FilterNotifier(T type) : _type = type;

//   T _type;

//   T get type => _type;

//   set type(T type) {
//     if (_type == type) return;

//     _type = type;
//     notifyListeners();
//   }
// }

class SubscriptionNotifier extends ChangeNotifier {
  SubscriptionNotifier(this.redditApi, bool isSubscriber)
      : _isSubscriber = isSubscriber;

  final RedditApi redditApi;
  static final _log = Logger('SubscriptionNotifier');

  // bool _isLoading = false;
  // bool get isLoading => _isLoading;

  Object? _error;
  Object? get error {
    final tmp = _error;
    _error = null;
    return tmp;
  }

  bool _isSubscriber;
  bool get isSubscriber => _isSubscriber;

  Future<void> subscribe(String name) async {
    if (isSubscriber) return;

    // _isLoading = true;
    // notifyListeners();

    try {
      await redditApi.subscribe(name);
      _isSubscriber = !isSubscriber;
    } on Exception catch (e) {
      _log.error(e);
      _error = e;
    }

    // _isLoading = false;
    notifyListeners();
  }

  Future<void> unsubscribe(String name) async {
    if (!isSubscriber) return;

    // _isLoading = true;
    // notifyListeners();

    try {
      await redditApi.unsubscribe(name);
      _isSubscriber = !isSubscriber;
    } on Exception catch (e) {
      _log.error(e);
      _error = e;
    }

    // _isLoading = false;
    notifyListeners();
  }
}

// TODO: add LoadingMixin, disable/enable button
// TODO: replace to ErrorMixin
abstract class VoteNotifier extends ChangeNotifier {
  VoteNotifier(this.redditApi, Vote vote, int score)
      : _vote = vote,
        _score = score;

  int _score;
  int get score => _score;

  final RedditApi redditApi;
  static final _log = Logger('VoteNotifier');

  Object? _error;
  Object? get error {
    final tmp = _error;
    _error = null;
    return tmp;
  }

  Vote _vote;
  Vote get vote => _vote;

  Future<void> upVote(String id) async {
    await _updateVote(id, Vote.up);
  }

  Future<void> downVote(String id) async {
    await _updateVote(id, Vote.down);
  }

  Future<void> clearVote(String id) async {
    await _updateVote(id, Vote.none);
  }

  Future<void> _updateVote(String id, Vote vote) async {
    if (_vote == vote) return;

    try {
      // await redditApi.submissionVote(id, vote);
      await _doVote(id, vote);
      _updateScore(vote);
      _vote = vote;
    } on Exception catch (e) {
      _log.error(e);
      _error = e;
    }

    notifyListeners();
  }

  void _updateScore(Vote newVote) {
    if (_vote == Vote.up) {
      if (newVote == Vote.down) {
        _score = _score - 2;
      } else if (newVote == Vote.none) {
        _score = _score - 1;
      }
    } else if (_vote == Vote.none) {
      if (newVote == Vote.down) {
        _score = _score - 1;
      } else if (newVote == Vote.up) {
        _score = _score + 1;
      }
    } else if (_vote == Vote.down) {
      if (newVote == Vote.up) {
        _score = _score + 2;
      } else if (newVote == Vote.none) {
        _score = _score + 1;
      }
    }
  }

  Future<void> _doVote(String id, Vote vote);
}

class SubmissionVoteNotifier extends VoteNotifier {
  SubmissionVoteNotifier(RedditApi redditApi, Submission submission)
      : super(redditApi, submission.likes, submission.score);

  @override
  Future<void> _doVote(String id, Vote vote) {
    return redditApi.submissionVote(id, vote);
  }
}

class CommentVoteNotifier extends VoteNotifier {
  CommentVoteNotifier(RedditApi redditApi, Comment comment)
      : super(redditApi, comment.likes, comment.score);

  @override
  Future<void> _doVote(String id, Vote vote) {
    return redditApi.commentVote(id, vote);
  }
}

abstract class SaveNotifier extends ChangeNotifier {
  SaveNotifier(this.redditApi, bool saved) : _saved = saved;

  bool _saved;
  bool get saved => _saved;

  final RedditApi redditApi;
  static final _log = Logger('SaveNotifier');

  Object? _error;
  Object? get error {
    final tmp = _error;
    _error = null;
    return tmp;
  }

  Future<void> save(String id) async {
    if (_saved) return;

    try {
      await _doSave(id);
      _saved = true;
    } on Exception catch (e) {
      _log.error(e);
      _error = e;
    }

    notifyListeners();
  }

  Future<void> unsave(String id) async {
    if (!_saved) return;

    try {
      await _doUnsave(id);
      _saved = false;
    } on Exception catch (e) {
      _log.error(e);
      _error = e;
    }

    notifyListeners();
  }

  Future<void> _doSave(String id);
  Future<void> _doUnsave(String id);
}

class SubmissionSaveNotifier extends SaveNotifier {
  SubmissionSaveNotifier(RedditApi redditApi, Submission submission)
      : super(redditApi, submission.saved);

  @override
  Future<void> _doSave(String id) {
    return redditApi.submissionSave(id);
  }

  @override
  Future<void> _doUnsave(String id) {
    return redditApi.submissionUnsave(id);
  }
}

class CommentSaveNotifier extends SaveNotifier {
  CommentSaveNotifier(RedditApi redditApi, Comment comment)
      : super(redditApi, comment.saved);

  @override
  Future<void> _doSave(String id) {
    return redditApi.commentSave(id);
  }

  @override
  Future<void> _doUnsave(String id) {
    return redditApi.commentUnsave(id);
  }
}



// class RedditNotifierFront extends ChangeNotifier {
//   RedditNotifierFront(this.redditApi);

//   final RedditApi redditApi;
//   SubType _type = SubType.best;

//   SubType get type => _type;

//   set type(SubType type) {
//     _type = type;
//     notifyListeners();
//   }

//   Stream<Submission> front({int limit = 10}) {
//     print(_type);
//     return redditApi.front(limit: limit, type: _type);
//   }
// }
