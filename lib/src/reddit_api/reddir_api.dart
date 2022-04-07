import 'dart:convert';
import 'dart:io';

import 'package:draw/draw.dart' as draw;

import 'submission.dart';

abstract class RedditApi {
  Future<List<Submission>> frontBest({required int limit});
  Future<List<Submission>> popular({required int limit});
}

class RedditApiImpl implements RedditApi {
  RedditApiImpl(this.reddit, this.anonymousReddit);

  final draw.Reddit reddit;
  final draw.Reddit anonymousReddit;

  Future<List<Submission>> frontBest({required int limit}) async {
    final subs = <Submission>[];
    await for (final v in reddit.front.best(limit: limit)) {
      final sub = Submission.fromDrawSubmission(v as draw.Submission);
      subs.add(sub);
    }
    return subs;
  }

  Future<List<Submission>> popular({required int limit}) async {
    final subs = <Submission>[];
    await for (final v in anonymousReddit.front.best(limit: limit)) {
      final sub = Submission.fromDrawSubmission(v as draw.Submission);
      subs.add(sub);
    }
    return subs;
  }
}

class FakeRedditApi implements RedditApi {
  FakeRedditApi(this.reddit, this.anonymousReddit);

  final draw.Reddit reddit;
  final draw.Reddit anonymousReddit;

  Future<List<Submission>> frontBest({required int limit}) async {
    final data =
        await File('data/user.reddit.front.best.limit_10.json').readAsString();
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => draw.Submission.parse(reddit, v))
        .map((v) => Submission.fromDrawSubmission(v))
        .toList();
  }

  Future<List<Submission>> popular({required int limit}) async {
    return frontBest(limit: limit);
  }
}
