import 'package:draw/draw.dart' as draw;
import 'package:flutter/foundation.dart';

import '../reddit_api/reddir_api.dart';
import '../reddit_api/submission.dart';

class RedditNotifier extends ChangeNotifier {
  RedditNotifier(this.redditApi);

  final RedditApi redditApi;
  List<Submission>? _frontBest;

  List<Submission>? get frontBest => _frontBest;

  Future<void> loadFrontBest({int limit = 10}) async {
    _frontBest = await redditApi.frontBest(limit: limit);
    notifyListeners();
  }
}
