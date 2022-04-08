import 'dart:convert';
import 'dart:io';

import 'package:draw/draw.dart' as draw;

import 'submission.dart';
import 'subreddit.dart';

abstract class RedditApi {
  Future<List<Submission>> frontBest({required int limit});
  Future<List<Submission>> popular({required int limit});
  Future<List<Subreddit>> userSubreddits({required int limit});
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
    // TODO: replace to
    // for submission in reddit.subreddit("all").best(limit=25):
    // https://praw.readthedocs.io/en/stable/code_overview/models/subreddit.html
    // TODO: remove anonymousReddit
    final subs = <Submission>[];
    await for (final v in anonymousReddit.front.best(limit: limit)) {
      final sub = Submission.fromDrawSubmission(v as draw.Submission);
      subs.add(sub);
    }
    return subs;
  }

  Future<List<Subreddit>> userSubreddits({required int limit}) async {
    final subs = <Subreddit>[];
    await for (final v in reddit.user.subreddits(limit: limit)) {
      final sub = Subreddit.fromDrawSubreddit(v);
      subs.add(sub);
    }
    return subs;
  }

  Future<List<Submission>> subredditPosts(String name,
      {required int limit}) async {
    final subs = <Submission>[];
    await for (final v
        in reddit.subreddit(name).stream.submissions(limit: limit)) {
      if (v != null) {
        final sub = Submission.fromDrawSubmission(v);
        subs.add(sub);
      }
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
        .map((v) => v as Map<String, dynamic>)
        .map((v) => draw.Submission.parse(reddit, v))
        .map((v) => Submission.fromDrawSubmission(v))
        .toList();
  }

  Future<List<Submission>> popular({required int limit}) async {
    return frontBest(limit: limit);
  }

  @override
  Future<List<Subreddit>> userSubreddits({required int limit}) async {
    final data =
        await File('data/user.reddit.subreddits.limit_100.json').readAsString();
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => draw.Subreddit.parse(reddit, {'data': v}))
        .map((v) => Subreddit.fromDrawSubreddit(v))
        .toList();
  }
}
