import 'package:draw/draw.dart' as draw;
import 'package:flutter/foundation.dart';

import '../model/submission.dart';

class RedditNotifier extends ChangeNotifier {
  RedditNotifier(this.reddit);

  final draw.Reddit reddit;
  List<Submission>? _frontBest;

  List<Submission>? get frontBest => _frontBest;

  Future<void> loadFrontBest({int limit = 10}) async {
    final subs = <Submission>[];
    await for (final v in reddit.front.best(limit: limit)) {
      final sub = Submission.fromDrawSubmission(v as draw.Submission);
      subs.add(sub);
    }
    _frontBest = subs;

    notifyListeners();
  }
}
