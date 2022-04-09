import 'package:draw/draw.dart' as draw;
import 'package:flutter/foundation.dart';

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
//   List<Submission>? get frontBest => _frontBest;
//   List<Subreddit>? get userSubreddits => _userSubreddits;

//   Future<void> loadFrontBest({int limit = 10}) async {
//     _frontBest = await redditApi.frontBest(limit: limit);
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

  Stream<Submission> frontBest({int limit = 10}) {
    return redditApi.frontBest(limit: limit, type: SubType.best);
  }

  Stream<Submission> popular({int limit = 10}) {
    return redditApi.popular(limit: limit);
  }

  Stream<Subreddit> userSubreddits({int limit = 10}) {
    return redditApi.userSubreddits(limit: limit);
    // ..sort((a, b) => a.displayName.compareTo(b.displayName));
  }

  Stream<Submission> subredditSubmissions(String name, {int limit = 10}) {
    return redditApi.subredditSubmissions(name, limit: limit);
  }
}

class RedditNotifierFront extends ChangeNotifier {
  RedditNotifierFront(this.redditApi);

  final RedditApi redditApi;
  SubType _type = SubType.best;

  SubType get type => _type;

  set type(SubType type) {
    _type = type;
    notifyListeners();
  }

  Stream<Submission> front({int limit = 10}) {
    print(_type);
    return redditApi.frontBest(limit: limit, type: _type);
  }
}
