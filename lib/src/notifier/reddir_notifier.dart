import 'package:draw/draw.dart' as draw;
import 'package:flutter/foundation.dart';

import '../reddit_api/trophy.dart';
import '../reddit_api/user.dart';
import '../reddit_api/comment.dart';
import '../reddit_api/reddir_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import '../reddit_api/subreddit.dart';

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
