import 'package:draw/draw.dart' as draw;

import '../model/submission.dart';

class RedditApi {
  RedditApi(this.reddit);

  final draw.Reddit reddit;

  Future<List<Submission>> frontBest({int limit = 10}) async {
    final subs = <Submission>[];
    await for (final v in reddit.front.best(limit: limit)) {
      final sub = Submission.fromDrawSubmission(v as draw.Submission);
      subs.add(sub);
    }
    return subs;
  }
}
