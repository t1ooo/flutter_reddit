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
import 'vote.dart';

// abstract class RedditApi {
//   Future<List<Submission>> front({required int limit});
//   Future<List<Submission>> popular({required int limit});
//   Future<List<Subreddit>> userSubreddits({required int limit});
// }

abstract class RedditApi {
  Stream<Submission> front({required int limit, required SubType type});
  Stream<Submission> popular({required int limit, required SubType type});

  Stream<Submission> subredditSubmissions(
    String name, {
    required int limit,
    required SubType type,
  });
  Future<Subreddit> subreddit(String name);

  Future<User> user(String name);
  Stream<Subreddit> userSubreddits({required int limit});
  Stream<Comment> userComments(String name, {required int limit});
  Stream<Submission> userSubmissions(String name, {required int limit});
  Future<List<Trophy>> userTrophies(String name);
  // Future<Submission> submission(String id);
  // Stream<Comment> submissionComments(String name, {required int limit});

  Future<void> subscribe(String name);
  Future<void> unsubscribe(String name);

  Future<Submission> submission(String id);

  Future<void> submissionVote(String id, Vote vote);
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

  Future<void> subscribe(String name) {
    return reddit.subreddit(name).subscribe();
  }

  Future<void> unsubscribe(String name) {
    return reddit.subreddit(name).unsubscribe();
  }

  Future<Submission> submission(String id) async {
    final subRef = reddit.submission(id: id);
    final sub = await subRef.populate();
    final comments = (sub.comments!.comments)
        .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => Comment.fromMap(v))
        .toList();
    // return Submission.fromMap(sub.data!, comments: sub.comments!.comments);
    return Submission.fromMap(sub.data!, comments: comments);
  }

  Future<Subreddit> subreddit(String name) async {
    final subRef = reddit.subreddit(name);
    final sub = await subRef.populate();
    return Subreddit.fromMap(sub.data!);
  }

  // TODO: use draw.Submission instead id for optimisation
  Future<void> submissionVote(String id, Vote vote) async {
    final s = await reddit.submission(id: id).populate();
    switch (vote) {
      case Vote.none:
        return s.clearVote();
      case Vote.up:
        return s.upvote();
      case Vote.down:
        return s.downvote();
    }
  }

  // Future<void> submissionUpvote(String id) async {
  //   return (await reddit.submission(id: id).populate()).upvote();
  // }

  // Future<void> submissionDownvote(String id) async {
  //   return (await reddit.submission(id: id).populate()).downvote();
  // }

  // Future<void> commentUpvote(String id) async {
  //   return (await reddit.comment(id: id).populate()).upvote();
  // }

  // Future<void> commentDownvote(String id) async {
  //   return (await reddit.comment(id: id).populate()).downvote();
  // }
}

class FakeRedditApi implements RedditApi {
  FakeRedditApi();

  Duration _delay = Duration(seconds: 1 ~/ 1);

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
    await Future.delayed(_delay);

    final data = await File('data/user.trophies.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => Trophy.fromMap(v));

    return items.toList();
  }

  Future<void> subscribe(String name) async {
    await Future.delayed(_delay);
    return;
  }

  Future<void> unsubscribe(String name) async {
    await Future.delayed(_delay);
    return;
  }

  Future<Submission> submission(String id) async {
    await Future.delayed(_delay);

    final subData = await File('data/submission.json').readAsString();
    final comData = await File('data/submission.comments.json').readAsString();

    // try {
    final comments = (jsonDecode(comData) as List<dynamic>)
        .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => Comment.fromMap(v))
        .toList();

    // print(comments);
    return Submission.fromMap(
      jsonDecode(subData) as Map,
      comments: comments,
    );
    // } catch (e, st) {
    // print(e);
    // print(st);
    // }

    // return placeholderSubmission();

    //     .map((v) => Trophy.fromMap(v));

    // final items = (jsonDecode(data) as List<dynamic>)
    //     .map((v) => v as Map<dynamic, dynamic>)
    //     .map((v) => Trophy.fromMap(v));
  }

  Future<Subreddit> subreddit(String name) async {
    final data = await File('data/subreddit.json').readAsString();
    return Subreddit.fromMap(jsonDecode(data) as Map);
  }

  Future<void> submissionVote(String id, Vote vote) async {
    await Future.delayed(_delay);
    return;
  }
}
