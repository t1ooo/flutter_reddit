import 'dart:convert';
import 'dart:io';

import 'package:draw/draw.dart' as draw;
// import 'package:draw/src/listing/listing_generator.dart' as draw;

import '../logging/logging.dart';
import '../util/cast.dart';
import 'submission.dart';
import 'submission_type.dart';
import 'subreddit.dart';

// abstract class RedditApi {
//   Future<List<Submission>> front({required int limit});
//   Future<List<Submission>> popular({required int limit});
//   Future<List<Subreddit>> userSubreddits({required int limit});
// }

abstract class RedditApi {
  Stream<Submission> front({required int limit, required SubType type});
  Stream<Submission> popular({required int limit, required SubType type});
  Stream<Subreddit> userSubreddits({required int limit});
  Stream<Submission> subredditSubmissions(
    String name, {
    required int limit,
  });
}

// class RedditApiImpl implements RedditApi {
//   RedditApiImpl(this.reddit);
//   // RedditApiImpl(this.reddit, this.anonymousReddit);

//   final draw.Reddit reddit;
//   // final draw.Reddit anonymousReddit;

//   Future<List<Submission>> front({required int limit}) async {
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

  Stream<Submission> _submissionsStream(
      Stream<draw.UserContent> s, SubType type) async* {
    await for (final v in s) {
      final dsub = cast<draw.Submission?>(v, null);
      if (dsub == null) {
        _log.warning('not draw.Submission: $v');
        continue;
      }
      final sub = Submission.fromDrawSubmission(dsub, type: type);
      yield sub;
    }
  }

  Stream<Submission> front({required int limit, required SubType type}) {
    final s = reddit.front;
    switch (type) {
      case SubType.best:
        return _submissionsStream(s.best(limit: limit), SubType.best);
      case SubType.hot:
        return _submissionsStream(s.hot(limit: limit), SubType.hot);
      case SubType.newest:
        return _submissionsStream(s.newest(limit: limit), SubType.newest);
      case SubType.top:
        return _submissionsStream(s.top(limit: limit), SubType.top);
      case SubType.rising:
        return _submissionsStream(s.rising(limit: limit), SubType.rising);
      case SubType.controversial:
        return _submissionsStream(
            s.controversial(limit: limit), SubType.controversial);
    }
  }

  // Stream<Submission> front({required int limit}) async* {
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

  // Stream<Submission> popular({required int limit}) async* {
  //   await for (final v in reddit.subreddit('all').hot(limit: limit)) {
  //     final dsub = cast<draw.Submission?>(v, null);
  //     if (dsub == null) {
  //       _log.warning('not draw.Submission: $v');
  //       continue;
  //     }
  //     final sub = Submission.fromDrawSubmission(dsub, type: SubType.hot);
  //     yield sub;
  //   }
  // }

  Stream<Submission> popular({required int limit, required SubType type}) {
    final s = reddit.subreddit('all');
    switch (type) {
      case SubType.best:
        throw Exception(
            'unsupported type: $type'); // TODO: find a solution without exception
      case SubType.hot:
        return _submissionsStream(s.hot(limit: limit), SubType.hot);
      case SubType.newest:
        return _submissionsStream(s.newest(limit: limit), SubType.newest);
      case SubType.top:
        return _submissionsStream(s.top(limit: limit), SubType.top);
      case SubType.rising:
        return _submissionsStream(s.rising(limit: limit), SubType.rising);
      case SubType.controversial:
        return _submissionsStream(
            s.controversial(limit: limit), SubType.controversial);
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
      final sub = Submission.fromDrawSubmission(dsub, type: SubType.hot);
      yield sub;
    }
  }

  Stream<Submission> userComments(
    String name, {
    required int limit,
  }) async* {
    await for (final v in reddit.redditor(name).comments.newest(limit: limit)) {
      final dsub = cast<draw.Submission?>(v, null);
      if (dsub == null) {
        _log.warning('not draw.Submission: $v');
        continue;
      }
      final sub = Submission.fromDrawSubmission(dsub, type: SubType.hot);
      yield sub;
    }
  }
}

class FakeRedditApi implements RedditApi {
  // FakeRedditApi(this.reddit, this.anonymousReddit);
  FakeRedditApi(this.reddit);

  final draw.Reddit reddit;
  Duration _delay = Duration(seconds: 1 ~/ 1000);

  Stream<Submission> front({
    required int limit,
    required SubType type,
  }) async* {
    print(type);
    final data =
        await File('data/user.reddit.front.best.limit_10.json').readAsString();
    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => draw.Submission.parse(reddit, v))
        .map((v) => Submission.fromDrawSubmission(v, type: type));
    // return Stream.fromIterable(items);
    for (final item in items) {
      await Future.delayed(_delay);
      yield item;
    }
  }

  Stream<Submission> popular({required int limit, required SubType type}) {
    return front(limit: limit, type: type);
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
    return front(limit: limit, type: SubType.best);
  }
}
