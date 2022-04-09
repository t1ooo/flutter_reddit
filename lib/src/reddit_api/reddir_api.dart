import 'dart:convert';
import 'dart:io';

import 'package:draw/draw.dart' as draw;
// import 'package:draw/src/listing/listing_generator.dart' as draw;

import '../logging/logging.dart';
import '../util/cast.dart';
import 'submission.dart';
import 'subreddit.dart';

// abstract class RedditApi {
//   Future<List<Submission>> frontBest({required int limit});
//   Future<List<Submission>> popular({required int limit});
//   Future<List<Subreddit>> userSubreddits({required int limit});
// }

abstract class RedditApi {
  Stream<Submission> frontBest({required int limit});
  Stream<Submission> popular({required int limit});
  Stream<Subreddit> userSubreddits({required int limit});
  Stream<Submission> subredditSubmissions(
    String name, {
    required int limit,
  });
}

enum Type {
  best,
  hot,
  newest,
  top,
  rising,
  controversial,
}

// class RedditApiImpl implements RedditApi {
//   RedditApiImpl(this.reddit);
//   // RedditApiImpl(this.reddit, this.anonymousReddit);

//   final draw.Reddit reddit;
//   // final draw.Reddit anonymousReddit;

//   Future<List<Submission>> frontBest({required int limit}) async {
//     final subs = <Submission>[];
//     await for (final v in reddit.front.best(limit: limit)) {
//       final sub = Submission.fromDrawSubmission(v as draw.Submission);
//       subs.add(sub);
//     }
//     return subs;
//   }

//   Future<List<Submission>> popular({required int limit}) async {
//     // TODO: replace to
//     // for submission in reddit.subreddit("all").best(limit=25):
//     // https://praw.readthedocs.io/en/stable/code_overview/models/subreddit.html
//     // TODO: remove anonymousReddit

//     final subs = <Submission>[];
//     // await for (final v in anonymousReddit.front.best(limit: limit)) {
//     await for (final v in reddit.subreddit('all').hot(limit:limit)) {
//       final sub = Submission.fromDrawSubmission(v as draw.Submission);
//       subs.add(sub);
//     }
//     return subs;
//   }

//   Future<List<Subreddit>> userSubreddits({required int limit}) async {
//     final subs = <Subreddit>[];
//     await for (final v in reddit.user.subreddits(limit: limit)) {
//       final sub = Subreddit.fromDrawSubreddit(v);
//       subs.add(sub);
//     }
//     return subs;
//   }

//   Future<List<Submission>> subredditSubmissions(
//     String name, {
//     required int limit,
//   }) async {
//     final subs = <Submission>[];
//     await for (final v
//         in reddit.subreddit(name).stream.submissions(limit: limit)) {
//       if (v != null) {
//         final sub = Submission.fromDrawSubmission(v);
//         subs.add(sub);
//       }
//     }
//     return subs;
//   }
// }

class RedditApiImpl implements RedditApi {
  RedditApiImpl(this.reddit);
  // RedditApiImpl(this.reddit, this.anonymousReddit);

  final draw.Reddit reddit;
  static final _log = Logger('RedditApiImpl');
  // final draw.Reddit anonymousReddit;

  Stream<Submission> _submissionsStream(Stream<draw.UserContent> s) async* {
    await for (final v in s) {
      final dsub = cast<draw.Submission?>(v, null);
      if (dsub == null) {
        _log.warning('not draw.Submission: $v');
        continue;
      }
      final sub = Submission.fromDrawSubmission(dsub);
      yield sub;
    }
  }

  Stream<Submission> frontBest({required int limit, Type type = Type.best}) {
    final front = reddit.front;
    switch (type) {
      case Type.best:
        return _submissionsStream(front.best(limit: limit));
      case Type.hot:
        return _submissionsStream(front.hot(limit: limit));
      case Type.newest:
        return _submissionsStream(front.newest(limit: limit));
      case Type.top:
        return _submissionsStream(front.top(limit: limit));
      case Type.rising:
        return _submissionsStream(front.rising(limit: limit));
      case Type.controversial:
        return _submissionsStream(front.controversial(limit: limit));
    }
  }

  // Stream<Submission> frontBest({required int limit}) async* {
  //   // draw.ListingGenerator.createBasicGenerator(reddit, '/best', limit: limit);

  //   await for (final v in reddit.front.best(limit: limit)) {
  //     final dsub = cast<draw.Submission?>(v, null);
  //     if (dsub == null) {
  //       _log.warning('not draw.Submission: $v');
  //       continue;
  //     }
  //     final sub = Submission.fromDrawSubmission(dsub);
  //     yield sub;
  //   }
  // }

  Stream<Submission> popular({required int limit}) async* {
    await for (final v in reddit.subreddit('all').hot(limit: limit)) {
      final dsub = cast<draw.Submission?>(v, null);
      if (dsub == null) {
        _log.warning('not draw.Submission: $v');
        continue;
      }
      final sub = Submission.fromDrawSubmission(dsub);
      yield sub;
    }
  }

  Stream<Subreddit> userSubreddits({required int limit}) async* {
    await for (final v in reddit.user.subreddits(limit: limit)) {
      final sub = Subreddit.fromDrawSubreddit(v);
      yield sub;
    }
  }

  Stream<Submission> subredditSubmissions(
    String name, {
    required int limit,
  }) async* {
    // in reddit.subreddit(name).stream.submissions(limit: limit)) {
    await for (final v in reddit.subreddit(name).hot(limit: limit)) {
      final dsub = cast<draw.Submission?>(v, null);
      if (dsub == null) {
        _log.warning('not draw.Submission: $v');
        continue;
      }
      final sub = Submission.fromDrawSubmission(dsub);
      yield sub;
    }
  }
}

class FakeRedditApi implements RedditApi {
  // FakeRedditApi(this.reddit, this.anonymousReddit);
  FakeRedditApi(this.reddit);

  final draw.Reddit reddit;
  Duration _delay = Duration(seconds: 1) ~/ 10;

  Stream<Submission> frontBest({required int limit}) async* {
    final data =
        await File('data/user.reddit.front.best.limit_10.json').readAsString();
    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => draw.Submission.parse(reddit, v))
        .map((v) => Submission.fromDrawSubmission(v));
    // return Stream.fromIterable(items);
    for (final item in items) {
      await Future.delayed(_delay);
      yield item;
    }
  }

  Stream<Submission> popular({required int limit}) {
    return frontBest(limit: limit);
  }

  @override
  Stream<Subreddit> userSubreddits({required int limit}) async* {
    final data =
        await File('data/user.reddit.subreddits.limit_100.json').readAsString();
    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => draw.Subreddit.parse(reddit, {'data': v}))
        .map((v) => Subreddit.fromDrawSubreddit(v));
    // .toList();
    for (final item in items) {
      await Future.delayed(_delay);
      yield item;
    }
  }

  Stream<Submission> subredditSubmissions(String name, {required int limit}) {
    return frontBest(limit: limit);
  }
}
