import 'dart:convert';
import 'dart:io';

import 'package:draw/draw.dart' as draw;
// import 'package:draw/src/listing/listing_generator.dart' as draw;

import '../logging/logging.dart';
import '../util/cast.dart';
import 'trophy.dart';
import 'user.dart';
import 'comment.dart';
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
    required SubType type,
  });
  Future<User> user(String name);
  Stream<Comment> userComments(String name, {required int limit});
  Stream<Submission> userSubmissions(String name, {required int limit});
  Future<List<Trophy>> userTrophies(String name);
  // Future<Submission> submission(String id);
  // Stream<Comment> submissionComments(String name, {required int limit});
}

class RedditApiImpl implements RedditApi {
  RedditApiImpl(this.reddit);

  final draw.Reddit reddit;
  static final _log = Logger('RedditApiImpl');

  Stream<Submission> _submissionsStream(
      Stream<draw.UserContent> s, SubType type) async* {
    await for (final v in s) {
      final dsub = cast<draw.Submission?>(v, null);
      if (dsub == null) {
        _log.warning('not draw.Submission: $v');
        continue;
      }
      if (dsub.data == null) {
        _log.warning('draw.Submission.data is empty: $v');
        continue;
      }
      final sub = Submission.fromMap(dsub.data!, type: type);
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

  Stream<Submission> popular({required int limit, required SubType type}) {
    final s = reddit.subreddit('all');
    switch (type) {
      case SubType.best:
        // TODO: find a solution without exception
        throw Exception('unsupported type: $type');
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
    // reddit.subreddits;
    await for (final v in reddit.user.subreddits(limit: limit)) {
      if (v.data == null) {
        _log.warning('draw.Subreddit.data is empty: $v');
        continue;
      }
      final sub = Subreddit.fromMap(v.data!);
      yield sub;
    }
  }

  Stream<Submission> subredditSubmissions(
    String name, {
    required int limit,
    required SubType type,
  }) {
    final s = reddit.subreddit(name);
    switch (type) {
      case SubType.best:
        // TODO: find a solution without exception
        throw Exception('unsupported type: $type');
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

  // TODO: MAYBE: add type support
  Stream<Comment> userComments(
    String name, {
    required int limit,
  }) async* {
    await for (final v in reddit.redditor(name).comments.newest(limit: limit)) {
      final dsub = cast<draw.Comment?>(v, null);
      if (dsub == null) {
        _log.warning('not draw.Submission: $v');
        continue;
      }
      if (dsub.data == null) {
        _log.warning('draw.Submission.data is empty: $v');
        continue;
      }
      final sub = Comment.fromMap(dsub.data!);
      yield sub;
    }
  }

  Future<User> user(String name) {
    throw UnimplementedError();
  }

  Stream<Submission> userSubmissions(String name, {required int limit}) {
    throw UnimplementedError();
  }

  Future<List<Trophy>> userTrophies(String name) async {
    final drawTrophies = await reddit.redditor('foo').trophies();
    final trophies = <Trophy>[];
    for (final trophy in drawTrophies) {
      if (trophy.data == null) {
        _log.warning('draw.Trophy.data is empty: $trophy');
        continue;
      }
      trophies.add(Trophy.fromMap(trophy.data!));
    }
    return trophies;
  }
}

class FakeRedditApi implements RedditApi {
  FakeRedditApi();

  Duration _delay = Duration(seconds: 1 ~/ 1000);

  Stream<Submission> front({
    required int limit,
    required SubType type,
  }) async* {
    print(type);
    final data = await File('data/user.front.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => Submission.fromMap(v, type: type));

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
    final data = await File('data/user.subreddits.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => Subreddit.fromMap(v));

    for (final item in items) {
      await Future.delayed(_delay);
      yield item;
    }
  }

  Stream<Submission> subredditSubmissions(
    String name, {
    required int limit,
    required SubType type,
  }) {
    return front(limit: limit, type: type);
  }

  Future<User> user(String name) async {
    final data = await File('data/user.info.json').readAsString();
    return User.fromMap(jsonDecode(data));
  }

  Stream<Comment> userComments(String name, {required int limit}) async* {
    final data = await File('data/user.comments.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => Comment.fromMap(v));

    for (final item in items) {
      await Future.delayed(_delay);
      yield item;
    }
  }

  Stream<Submission> userSubmissions(String name, {required int limit}) async* {
    final data = await File('data/user.submissions.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => Submission.fromMap(v, type: SubType.hot));

    for (final item in items) {
      await Future.delayed(_delay);
      yield item;
    }
  }

  Future<List<Trophy>> userTrophies(String name) async {
    final data = await File('data/user.trophies.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => Trophy.fromMap(v));

    return items.toList();
  }
}
