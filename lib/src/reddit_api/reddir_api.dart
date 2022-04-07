import 'dart:convert';
import 'dart:io';

import 'package:draw/draw.dart' as draw;

import 'submission.dart';

abstract class RedditApi {
  RedditApi(this.reddit);

  final draw.Reddit reddit;

  Future<List<Submission>> frontBest({int limit = 10});
}

class RedditApiImpl implements RedditApi {
  RedditApiImpl(this.reddit);

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

class FakeRedditApi implements RedditApi {
  FakeRedditApi(this.reddit);

  final draw.Reddit reddit;

  Future<List<Submission>> frontBest({int limit = 10}) async {
    final data =
        await File('data/user.reddit.front.best.limit_10.json').readAsString();
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => draw.Submission.parse(reddit, v))
        .map((v) => Submission.fromDrawSubmission(v))
        .toList();
  }
}
