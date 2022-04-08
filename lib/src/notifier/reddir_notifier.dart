import 'package:draw/draw.dart' as draw;
import 'package:flutter/foundation.dart';

import '../reddit_api/reddir_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/subreddit.dart';

class RedditNotifier extends ChangeNotifier {
  RedditNotifier(this.redditApi);

  final RedditApi redditApi;
  List<Submission>? _frontBest;
  List<Submission>? _popular;
  List<Subreddit>? _userSubreddits;

  List<Submission>? get popular => _popular;
  List<Submission>? get frontBest => _frontBest;
  List<Subreddit>? get userSubreddits => _userSubreddits;

  Future<void> loadFrontBest({int limit = 10}) async {
    _frontBest = await redditApi.frontBest(limit: limit);
    notifyListeners();
  }

  Future<void> loadPopular({int limit = 10}) async {
    _popular = await redditApi.popular(limit: limit);
    notifyListeners();
  }

  Future<void> loadUserSubreddits({int limit = 10}) async {
    _userSubreddits = await redditApi.userSubreddits(limit: limit);
    notifyListeners();
  }
}
