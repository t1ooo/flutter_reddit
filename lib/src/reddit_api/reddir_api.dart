import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:draw/draw.dart' as draw;
import 'package:draw/src/listing/listing_generator.dart' as draw;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../logging/logging.dart';
import 'message.dart';
import 'parse.dart';
import 'auth.dart';
import 'trophy.dart';
import 'user.dart';
import 'comment.dart';
import 'submission.dart';
import 'submission_type.dart';
import 'subreddit.dart';
import 'like.dart';

typedef Sort = draw.Sort;

String removeSubredditPrefix(String name) {
  const prefix = 'r/';
  if (name.startsWith(prefix)) {
    return name.substring(prefix.length);
  }
  return name;
}

class UserSaved {
  UserSaved(this.submissions, this.comments);
  List<Submission> submissions;
  List<Comment> comments;
}

abstract class RedditApi {
  Future<List<Submission>> front({
    required int limit,
    required FrontSubType type,
  });
  Future<List<Submission>> popular({required int limit, required SubType type});

  Future<Subreddit> subreddit(String name);
  // Future<String> subredditIcon(String name);

  Future<User> user(String name);
  Future<List<Comment>> userComments(String name, {required int limit});
  Future<List<Submission>> userSubmissions(String name, {required int limit});
  Future<List<Trophy>> userTrophies(String name);
  Future<UserSaved> userSaved(String name, {required int limit});
  Future<void> userBlock(String name);
  Future<void> userUnblock(String name);

  Future<void> subredditSubscribe(String name);
  Future<void> subredditUnsubscribe(String name);
  Future<void> subredditFavorite(String name);
  Future<void> subredditUnfavorite(String name);
  Future<List<Submission>> subredditSubmissions(
    String name, {
    required int limit,
    required SubType type,
  });

  Future<Submission> submission(String id);
  Future<void> submissionLike(String id, Like like);
  Future<void> submissionSave(String id);
  Future<void> submissionUnsave(String id);
  Future<void> submissionHide(String id);
  Future<void> submissionUnhide(String id);
  Future<Comment> submissionReply(String id, String body);
  Future<void> submissionReport(String id, String reason);

  Future<void> commentLike(String id, Like like);
  Future<void> commentSave(String id);
  Future<void> commentUnsave(String id);
  Future<Comment> commentReply(String id, String body);
  Future<void> commentReport(String id, String reason);

  Future<User?> currentUser();
  Future<List<Subreddit>> currentUserSubreddits({required int limit});

  Future<List<Submission>> search(
    String query, {
    required int limit,
    required Sort sort,
    String subreddit = 'all',
  });
  Future<List<Subreddit>> searchSubreddits(String query, {required int limit});
  Future<List<Subreddit>> searchSubredditsByName(String query);

  Future<Submission> submit({
    required String subreddit,
    required String title,
    String? selftext,
    String? url,
    bool resubmit = true,
    bool sendReplies = true,
    bool nsfw = false,
    bool spoiler = false,
  });

  bool get isLoggedIn;
  Future<bool> loginSilently();
  Future<void> login();
  Future<void> logout();

  Future<List<Message>> inboxMessages();
}

class RedditApiImpl implements RedditApi {
  RedditApiImpl(this.clientId, this.redirectUri, this.credentials);

  final userAgent = 'Flutter Client';

  bool get isLoggedIn => _reddit != null;

  Future<void> logout() async {
    _reddit = null;
    await credentials.delete();
  }

  Future<bool> loginSilently() async {
    if (_reddit != null) {
      return true;
    }

    final credentialsJson = await credentials.read();

    if (credentialsJson == '') {
      return false;
    }

    _reddit = draw.Reddit.restoreAuthenticatedInstance(
      credentialsJson,
      clientId: clientId,
      userAgent: userAgent,
      redirectUri: redirectUri,
    );

    return true;
  }

  Future<void> login() async {
    if (_reddit != null) {
      return;
    }

    final s = AuthServer(redirectUri);

    _reddit = draw.Reddit.createInstalledFlowInstance(
      clientId: clientId,
      userAgent: userAgent,
      redirectUri: redirectUri,
    );

    final authUrl = reddit.auth.url(['*'], 'state');
    launch(authUrl.toString());

    final authCode = await s.stream.first;
    await reddit.auth.authorize(authCode);

    await credentials.write(reddit.auth.credentials.toJson());

    await s.close();
  }

  final String clientId;

  final Uri redirectUri;
  final Credentials credentials;

  static final _log = getLogger('RedditApiImpl');

  draw.Reddit? _reddit;
  draw.Reddit get reddit {
    if (_reddit == null) {
      throw Exception('not logged in');
    }
    return _reddit!;
  }

  // Future<List<Submission>> _submissionsStream(
  //     Future<List<draw.UserContent>> s) async {
  //   s.map
  //     try {
  //       Submission.fromJson(
  //         (v as draw.Submission).data as Map<String, dynamic>,
  //       );
  //     } on TypeError catch (_) {
  //       _log.warning('fail to parse Submission: $v');
  //       continue;
  //     } on Exception catch (_) {
  //       _log.warning('fail to parse Submission: $v');
  //       continue;
  //     }
  //   }
  // }

  Submission? _parseSubmission(draw.UserContent v) {
    try {
      return Submission.fromJson(
        (v as draw.Submission).data as Map<String, dynamic>,
      );
    } on TypeError catch (_) {
      _log.warning('fail to parse Submission: $v');
    } on Exception catch (_) {
      _log.warning('fail to parse Submission: $v');
    }
    return null;
  }

  Subreddit? _parseSubreddit(draw.Subreddit v) {
    try {
      return Subreddit.fromJson(v.data! as Map<String, dynamic>);
    } on TypeError catch (_) {
      _log.warning('fail to parse Subreddit: $v');
    } on Exception catch (_) {
      _log.warning('fail to parse Subreddit: $v');
    }
    return null;
  }

  Message? _parseMessage(draw.Message v) {
    try {
      return Message.fromJson(v.data! as Map<String, dynamic>);
    } on TypeError catch (_) {
      _log.warning('fail to parse Message: $v');
    } on Exception catch (_) {
      _log.warning('fail to parse Message: $v');
    }
    return null;
  }

  Comment? _parseComment(draw.UserContent v) {
    try {
      return Comment.fromJson(
        (v as draw.Comment).data! as Map<String, dynamic>,
      );
    } on TypeError catch (_) {
      _log.warning('fail to parse Comment: $v');
    } on Exception catch (_) {
      _log.warning('fail to parse Comment: $v');
    }
    return null;
  }

  User? _parseUser(draw.Redditor v) {
    try {
      return User.fromJson(v.data! as Map<String, dynamic>);
    } on TypeError catch (_) {
      _log.warning('fail to parse Comment: $v');
    } on Exception catch (_) {
      _log.warning('fail to parse Comment: $v');
    }
    return null;
  }

  Trophy? _parseTrophy(draw.Trophy v) {
    try {
      return Trophy.fromJson(v.data! as Map<String, dynamic>);
    } on TypeError catch (_) {
      _log.warning('fail to parse Trophy: $v');
    } on Exception catch (_) {
      _log.warning('fail to parse Trophy: $v');
    }
    return null;
  }

  Future<List<R>> _parseStream<T, R>(Stream<T> s, R? Function(T) parser) async {
    return (await s.toList()).map(parser).whereType<R>().toList();
  }

  Future<List<Submission>> _parseSubmissionStream(
    Stream<draw.UserContent> s,
  ) async {
    return _parseStream<draw.UserContent, Submission>(s, _parseSubmission);
  }

  Future<List<Comment>> _parseCommentStream(Stream<draw.UserContent> s) async {
    return _parseStream<draw.UserContent, Comment>(s, _parseComment);
  }

  Future<List<Subreddit>> _parseSubredditStream(
      Stream<draw.Subreddit> s) async {
    return _parseStream<draw.Subreddit, Subreddit>(s, _parseSubreddit);
  }

  Future<List<Message>> _parseMessageStream(Stream<draw.Message> s) async {
    return _parseStream<draw.Message, Message>(s, _parseMessage);
  }

  Future<List<Submission>> front(
      {required int limit, required FrontSubType type}) {
    final s = reddit.front;
    switch (type) {
      case FrontSubType.best:
        return _parseSubmissionStream(s.best(limit: limit));
      case FrontSubType.hot:
        return _parseSubmissionStream(s.hot(limit: limit));
      case FrontSubType.newest:
        return _parseSubmissionStream(s.newest(limit: limit));
      case FrontSubType.top:
        return _parseSubmissionStream(s.top(limit: limit));
      case FrontSubType.rising:
        return _parseSubmissionStream(s.rising(limit: limit));
      case FrontSubType.controversial:
        return _parseSubmissionStream(s.controversial(limit: limit));
    }
  }

  Future<List<Submission>> popular(
      {required int limit, required SubType type}) {
    return subredditSubmissions('popular', limit: limit, type: type);
  }

  Future<List<Subreddit>> currentUserSubreddits({required int limit}) {
    return _parseSubredditStream(reddit.user.subreddits(limit: limit));
  }

  Future<List<Submission>> subredditSubmissions(
    String name, {
    required int limit,
    required SubType type,
  }) {
    name = removeSubredditPrefix(name);
    final s = reddit.subreddit(name);
    switch (type) {
      case SubType.hot:
        return _parseSubmissionStream(s.hot(limit: limit));
      case SubType.newest:
        return _parseSubmissionStream(s.newest(limit: limit));
      case SubType.top:
        return _parseSubmissionStream(s.top(limit: limit));
      case SubType.rising:
        return _parseSubmissionStream(s.rising(limit: limit));
      case SubType.controversial:
        return _parseSubmissionStream(s.controversial(limit: limit));
    }
  }

  Future<User> user(String name) async {
    final redditorRef = await reddit.redditor(name);
    final redditor = await redditorRef.populate();
    // return User.fromJson(redditor.data! as Map<String, dynamic>);
    return _parseUser(redditor)!;
  }

  Future<void> userBlock(String name) async {
    final params = {'name': name};
    await reddit.post('/api/block_user/', params);
  }

  Future<void> userUnblock(String name) async {
    final redditorRef = await reddit.redditor(name);
    // final redditor = await redditorRef.populate();
    // return User.fromJson(redditor.data! as Map<String, dynamic>);
    return redditorRef.unblock();
  }

  // TODO: MAYBE: add type support
  Future<List<Comment>> userComments(
    String name, {
    required int limit,
  }) {
    // await for (final v in reddit.redditor(name).comments.newest(limit: limit)) {
    // final dsub = cast<draw.Comment?>(v, null);
    // if (dsub == null) {
    //   _log.warning('not draw.Submission: $v');
    //   continue;
    // }
    // if (dsub.data == null) {
    //   _log.warning('draw.Submission.data is empty: $v');
    //   continue;
    // }
    // final sub = Comment.fromJson(dsub.data! as Map<String, dynamic>);
    // yield sub;

    //   try {
    //     yield Comment.fromJson(
    //       (v as draw.Comment).data! as Map<String, dynamic>,
    //     );
    //   } on TypeError catch (_) {
    //     _log.warning('fail to parse Comment: $v');
    //     continue;
    //   } on Exception catch (_) {
    //     _log.warning('fail to parse Comment: $v');
    //     continue;
    //   }
    // }
    // return _commentsStream(reddit.redditor(name).comments.newest(limit: limit));
    return _parseCommentStream(
        reddit.redditor(name).comments.newest(limit: limit));
  }

// TODO: MAYBE: add type support
  Future<List<Submission>> userSubmissions(String name, {required int limit}) {
    // await for (final v
    // in reddit.redditor(name).submissions.newest(limit: limit)) {
    // final dsub = cast<draw.Comment?>(v, null);
    // if (dsub == null) {
    //   _log.warning('not draw.Submission: $v');
    //   continue;
    // }
    // if (dsub.data == null) {
    //   _log.warning('draw.Submission.data is empty: $v');
    //   continue;
    // }
    // final sub = Submission.fromJson(dsub.data! as Map<String, dynamic>);
    // yield sub;
    // }
    return _parseSubmissionStream(
        reddit.redditor(name).submissions.newest(limit: limit));
  }

  Future<List<Trophy>> userTrophies(String name) async {
    // final drawTrophies = await reddit.redditor('foo').trophies();
    return (await reddit.redditor(name).trophies())
        .map(_parseTrophy)
        .whereType<Trophy>()
        .toList();
    // final trophies = <Trophy>[];
    // for (final v in drawTrophies) {
    //   // if (trophy.data == null) {
    //   //   _log.warning('draw.Trophy.data is empty: $trophy');
    //   //   continue;
    //   // }
    //   // trophies.add(Trophy.fromJson(trophy.data! as Map<String, dynamic>));
    //   try {
    //     trophies.add(Trophy.fromJson(v.data! as Map<String, dynamic>));
    //   } on TypeError catch (_) {
    //     _log.warning('fail to parse Trophy: $v');
    //     continue;
    //   } on Exception catch (_) {
    //     _log.warning('fail to parse Trophy: $v');
    //     continue;
    //   }
    // }
    // return trophies;
  }

  // TODO: rename to subredditSubscribe
  Future<void> subredditSubscribe(String name) {
    name = removeSubredditPrefix(name);
    return reddit.subreddit(name).subscribe();
  }

  Future<void> subredditUnsubscribe(String name) {
    name = removeSubredditPrefix(name);
    return reddit.subreddit(name).unsubscribe();
  }

  Future<void> subredditFavorite(String name) async {
    name = removeSubredditPrefix(name);
    await reddit.post(
      '/api/favorite/',
      {
        'make_favorite': 'true',
        'sr_name': name,
        'api_type': 'json',
      },
      objectify: false,
    );
  }

  Future<void> subredditUnfavorite(String name) async {
    name = removeSubredditPrefix(name);
    await reddit.post(
      '/api/favorite/',
      {
        'make_favorite': 'false',
        'sr_name': name,
        'api_type': 'json',
      },
      objectify: false,
    );
  }

  Future<Submission> submission(String id) async {
    final subRef = reddit.submission(id: id);
    final sub = await subRef.populate();
    final comments = (sub.comments!.comments)
        .map((v) => Comment.fromJson(v as Map<String, dynamic>))
        .toList();
    return Submission.fromJson(sub.data!, comments: comments);
  }

  Future<Subreddit> subreddit(String name) async {
    name = removeSubredditPrefix(name);
    final subRef = reddit.subreddit(name);
    final sub = await subRef.populate();
    return Subreddit.fromJson(sub.data! as Map<String, dynamic>);
  }

  // Future<String> subredditIcon(String name) async {
  //   name = removeSubredditPrefix(name);
  //   final subRef = reddit.subreddit(name);
  //   final sub = await subRef.populate();
  //   return Subreddit.fromJson(sub.data! as Map<String, dynamic>).communityIcon;
  // }

  Future<void> submissionLike(String id, Like like) async {
    final s = await reddit.submission(id: id).populate();
    return _like(s, like);
  }

  Future<void> commentLike(String id, Like like) async {
    final s = await reddit.comment(id: id).populate();
    return _like(s, like);
  }

  Future<void> _like(draw.VoteableMixin s, Like like) async {
    switch (like) {
      case Like.none:
        return s.clearVote();
      case Like.up:
        return s.upvote();
      case Like.down:
        return s.downvote();
    }
  }

  Future<void> submissionSave(String id) async {
    final s = await reddit.submission(id: id).populate();
    return s.save();
  }

  Future<void> submissionUnsave(String id) async {
    final s = await reddit.submission(id: id).populate();
    return s.unsave();
  }

  Future<void> submissionHide(String id) async {
    final s = await reddit.submission(id: id).populate();
    return s.hide();
  }

  Future<void> submissionUnhide(String id) async {
    final s = await reddit.submission(id: id).populate();
    return s.unhide();
  }

  Future<void> commentSave(String id) async {
    final s = await reddit.comment(id: id).populate();
    return s.save();
  }

  Future<void> commentUnsave(String id) async {
    final s = await reddit.comment(id: id).populate();
    return s.unsave();
  }

  Future<User?> currentUser() async {
    final redditor = await reddit.user.me();
    if (redditor == null) {
      return null;
    }
    return User.fromJson(redditor.data! as Map<String, dynamic>);
  }

  Future<UserSaved> userSaved(String name, {required int limit}) async {
    final redditorRef = reddit.redditor(name);

    final submissions = <Submission>[];
    final comments = <Comment>[];
    await for (final v in redditorRef.saved(limit: limit)) {
      try {
        if (v is draw.Submission)
          submissions.add(_parseSubmission(v)!);
        else if (v is draw.Comment)
          comments.add(_parseComment(v)!);
        else
          _log.warning('undefined type');
      } on TypeError catch (e, st) {
        _log.error('', e, st);
      } on Exception catch (e, st) {
        _log.error('', e, st);
      }
    }

    return UserSaved(submissions, comments);
  }

  Future<List<Submission>> search(
    String query, {
    required int limit,
    required Sort sort,
    String subreddit = 'all',
  }) {
    subreddit = removeSubredditPrefix(subreddit);
    final params = {'limit': limit.toString()};
    // await for (final v
    //     in reddit.subreddit(subreddit).search(query, params: params)) {
    //   final dsub = cast<draw.Submission?>(v, null);
    //   if (dsub == null) {
    //     _log.warning('not draw.Submission: $v');
    //     continue;
    //   }
    //   if (dsub.data == null) {
    //     _log.warning('draw.Submission.data is empty: $v');
    //     continue;
    //   }
    //   yield Submission.fromJson(dsub.data! as Map<String, dynamic>);
    // }
    return _parseSubmissionStream(
        reddit.subreddit(subreddit).search(query, params: params));
  }

  Future<List<Subreddit>> searchSubreddits(String query, {required int limit}) {
    // await for (final v in reddit.subreddits.search(query, limit: limit)) {
    //   final dsub = cast<draw.Subreddit?>(v, null);
    //   if (dsub == null) {
    //     _log.warning('not draw.Subreddit: $v');
    //     continue;
    //   }
    //   if (dsub.data == null) {
    //     _log.warning('draw.Subreddit.data is empty: $v');
    //     continue;
    //   }
    //   yield Subreddit.fromJson(dsub.data! as Map<String, dynamic>);
    // }
    return _parseSubredditStream(reddit.subreddits
        .search(query, limit: limit)
        .map((v) => v as draw.Subreddit));
  }

  Future<List<Subreddit>> searchSubredditsByName(
    String query,
  ) async {
    return (await reddit.subreddits.searchByName(query))
        .map((v) => v as draw.Subreddit)
        .map(_parseSubreddit)
        .whereType<Subreddit>()
        .toList();
    // for (final v in await reddit.subreddits.searchByName(query)) {
    //   final dsub = cast<draw.Subreddit?>(v, null);
    //   if (dsub == null) {
    //     _log.warning('not draw.Subreddit: $v');
    //     continue;
    //   }
    //   if (dsub.data == null) {
    //     _log.warning('draw.Subreddit.data is empty: $v');
    //     continue;
    //   }
    //   yield Subreddit.fromJson(dsub.data! as Map<String, dynamic>);
    // }
  }

  Future<Comment> submissionReply(String id, String body) async {
    final subRef = reddit.submission(id: id);
    final sub = await subRef.populate();
    final comment = await sub.reply(body);
    return _parseComment(comment)!;
  }

  Future<void> submissionReport(String id, String reason) async {
    final subRef = reddit.submission(id: id);
    final sub = await subRef.populate();
    return sub.report(reason);
    // final comment = await sub.reply(body);
    // return _parseComment(comment)!;
  }

  Future<void> commentReport(String id, String reason) async {
    final commentRef = reddit.comment(id: id);
    final comment = await commentRef.populate();
    return comment.report(reason);
  }

  Future<Comment> commentReply(String id, String body) async {
    final commentRef = reddit.comment(id: id);
    final comment = await commentRef.populate();
    final commentReply = await comment.reply(body);
    return _parseComment(commentReply)!;
  }

  Future<Submission> submit({
    required String subreddit,
    required String title,
    String? selftext,
    String? url,
    bool resubmit = true,
    bool sendReplies = true,
    bool nsfw = false,
    bool spoiler = false,
  }) async {
    final sub = await reddit.subreddit(subreddit).submit(
          title,
          selftext: selftext,
          url: url,
          resubmit: resubmit,
          sendReplies: sendReplies,
          nsfw: nsfw,
          spoiler: spoiler,
        );
    return _parseSubmission(sub)!;
  }

  Future<List<Message>> inboxMessages() async {
    // await for (final v in reddit.inbox.messages()) {
    //   final dsub = cast<draw.Message?>(v, null);
    //   if (dsub == null) {
    //     _log.warning('not draw.Subreddit: $v');
    //     continue;
    //   }
    //   if (dsub.data == null) {
    //     _log.warning('draw.Subreddit.data is empty: $v');
    //     continue;
    //   }
    //   yield Message.fromJson(dsub.data! as Map<String, dynamic>);
    // }
    return _parseMessageStream(reddit.inbox.messages());
  }
}

class FakeRedditApi implements RedditApi {
  FakeRedditApi();

  static final _log = getLogger('FakeRedditApi');

  Duration _delay = Duration(seconds: 1 ~/ 2);

  Map _addType(Map v, Enum type) {
    v['title'] = '$type: ${v['title']}';
    return v;
  }

  Future<List<Submission>> front({
    required int limit,
    required FrontSubType type,
  }) async {
    _log.info('front($limit, $type)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await File('data/user.front.json').readAsString();
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => _addType(v, type))
        .map((v) => Submission.fromJson(v))
        .take(limit)
        .toList();
  }

  Random _random = Random(42);

  Future<List<Submission>> popular({
    required int limit,
    required SubType type,
  }) async {
    _log.info('popular($limit, $type)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await File('data/popular.json').readAsString();

    return (jsonDecode(data) as List<dynamic>)
        .map((v) => _addType(v, type))
        .map((v) => Submission.fromJson(v))
        .take(limit)
        .toList();
  }

  @override
  Future<List<Subreddit>> currentUserSubreddits({required int limit}) async {
    _log.info('currentUserSubreddits($limit)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await File('data/user.subreddits.json').readAsString();
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => Subreddit.fromJson(v))
        .take(limit)
        .toList();
  }

  Future<List<Submission>> subredditSubmissions(
    String name, {
    required int limit,
    required SubType type,
  }) async {
    _log.info('subredditSubmissions($name, $limit, $type)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    name = removeSubredditPrefix(name);
    final data = await File('data/subreddit.submissions.json').readAsString();
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => _addType(v, type))
        .map((v) => Submission.fromJson(v))
        .take(limit)
        .toList();
  }

  Future<User> user(String name) async {
    _log.info('user($name)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await File('data/user.info.json').readAsString();
    return User.fromJson(jsonDecode(data));
  }

  Future<List<Comment>> userComments(String name, {required int limit}) async {
    _log.info('userComments($name, $limit)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await File('data/user.comments.json').readAsString();
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => Comment.fromJson(v))
        .take(limit)
        .toList();
  }

  Future<List<Submission>> userSubmissions(
    String name, {
    required int limit,
  }) async {
    _log.info('userSubmissions($name, $limit)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await File('data/user.submissions.json').readAsString();
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => Submission.fromJson(v))
        .take(limit)
        .toList();
  }

  Future<List<Trophy>> userTrophies(String name) async {
    _log.info('userTrophies($name)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await File('data/user.trophies.json').readAsString();
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => Trophy.fromJson(v))
        .toList();
  }

  Future<void> subredditSubscribe(String name) async {
    _log.info('subscribe($name)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    name = removeSubredditPrefix(name);
    return;
  }

  Future<void> subredditUnsubscribe(String name) async {
    _log.info('unsubscribe($name)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    name = removeSubredditPrefix(name);
    return;
  }

  Future<void> subredditFavorite(String name) async {
    await Future.delayed(_delay);
    _log.info('subredditFavorite($name)');
    return;
  }

  Future<void> subredditUnfavorite(String name) async {
    _log.info('subredditUnfavorite($name)');
    await Future.delayed(_delay);
    return;
  }

  Future<Submission> submission(String id) async {
    _log.info('submission($id)');
    await Future.delayed(_delay);
    _mustLoggedIn();

    final subData = await File('data/submission.json').readAsString();
    final comData = await File('data/submission.comments.json').readAsString();

    final comments = (jsonDecode(comData) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => Comment.fromJson(v))
        .toList();

    return Submission.fromJson(
      jsonDecode(subData) as Map,
      comments: comments,
    );
  }

  Future<Subreddit> subreddit(String name) async {
    _log.info('subreddit($name)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    name = removeSubredditPrefix(name);
    final files = ['data/subreddit.1.json', 'data/subreddit.2.json'];
    final data =
        await File(files[Random().nextInt(files.length)]).readAsString();
    final map = jsonDecode(data) as Map;
    map['user_is_subscriber'] = _random.nextInt(1000) % 2 == 0;
    return Subreddit.fromJson(map as Map<String, dynamic>);
  }

  Future<void> submissionLike(String id, Like like) async {
    _log.info('submissionLike($id, $like)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    return;
  }

  @override
  Future<void> commentLike(String id, Like like) async {
    _log.info('commentLike($id, $like)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    return;
  }

  Future<void> submissionSave(String id) async {
    _log.info('submissionSave($id)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    return;
  }

  Future<void> submissionUnsave(String id) async {
    _log.info('submissionUnsave($id)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    return;
  }

  Future<void> submissionHide(String id) async {
    _log.info('submissionHide($id)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    return;
  }

  Future<void> submissionUnhide(String id) async {
    _log.info('submissionUnhide($id)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    return;
  }

  Future<void> commentSave(String id) async {
    _log.info('commentSave($id)');
    await Future.delayed(_delay);
    _mustLoggedIn();

    return;
  }

  Future<void> commentUnsave(String id) async {
    _log.info('commentUnsave($id)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    return;
  }

  Future<User?> currentUser() async {
    _log.info('currentUser()');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await File('data/user.current.info.json').readAsString();
    return User.fromJson(jsonDecode(data));
  }

  Future<UserSaved> userSaved(String name, {required int limit}) async {
    _log.info('userSaved($name, $limit)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await File('data/user.current.saved.json').readAsString();
    final submissions = <Submission>[];
    final comments = <Comment>[];

    final items = (jsonDecode(data) as List<dynamic>)
        .take(limit)
        .map((v) => v as Map<String, dynamic>)
        .forEach((v) {
      if (v['name']?.contains('t1_'))
        comments.add(Comment.fromJson(v));
      else
        submissions.add(Submission.fromJson(v));
    });

    return UserSaved(
      submissions + submissions + submissions,
      comments + comments + comments,
    );
  }

  // Future<String> subredditIcon(String name) async {
  //   _log.info('subredditIcon($name)');
  //   await Future.delayed(_delay);
  //   _mustLoggedIn();
  //   name = removeSubredditPrefix(name);
  //   return 'https://styles.redditmedia.com/t5_2ql8s/styles/communityIcon_42dkzkktri741.png?width=256&s=be327c0205feb19fef8a00fe88e53683b2f81adf';
  // }

  Future<List<Submission>> search(
    String query, {
    required int limit,
    required Sort sort,
    String subreddit = 'all',
  }) async {
    _log.info('search($query, $limit, $sort, $subreddit)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    subreddit = removeSubredditPrefix(subreddit);
    final data = await File('data/search.json').readAsString();

    return (jsonDecode(data) as List<dynamic>)
        .map((v) => _addType(v, sort))
        .map((v) => Submission.fromJson(v))
        .take(limit)
        .toList();
  }

  Future<List<Subreddit>> searchSubreddits(
    String query, {
    required int limit,
  }) async {
    _log.info('searchSubreddits($query, $limit)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await File('data/subreddits.search.json').readAsString();
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => Subreddit.fromJson(v))
        .take(limit)
        .toList();
  }

  Future<List<Subreddit>> searchSubredditsByName(String query) async {
    _log.info('searchSubredditsByName($query)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data =
        await File('data/subreddits.search.by.name.json').readAsString();
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => Subreddit.fromJson(v))
        .toList();
  }

  Future<Comment> submissionReply(String id, String body) async {
    _log.info('submissionReply($id, $body)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return Comment.fromJson({'body': body});
  }

  Future<Comment> commentReply(String id, String body) async {
    _log.info('commentReply($id, $body)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return Comment.fromJson({'body': body});
  }

  Future<String> _loginPath() async {
    return (await getTemporaryDirectory()).path + '/fake_reddit_api.login';
  }

  void _mustLoggedIn() {
    if (!_isLoggedIn) {
      throw Exception('login to continue');
    }
  }

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> login() async {
    _log.info('login()');

    await File(await _loginPath()).create();
    _isLoggedIn = true;
    return;
  }

  Future<bool> loginSilently() async {
    await Future.delayed(_delay);
    _isLoggedIn = await File(await _loginPath()).exists();
    _log.info('loginSilently: $_isLoggedIn');
    return _isLoggedIn;
  }

  Future<void> logout() async {
    _log.info('logout()');
    await File(await _loginPath()).delete();
    _isLoggedIn = false;
    return;
  }

  Future<Submission> submit({
    required String subreddit,
    required String title,
    String? selftext,
    String? url,
    bool resubmit = true,
    bool sendReplies = true,
    bool nsfw = false,
    bool spoiler = false,
  }) async {
    await Future.delayed(_delay);
    return Submission.fromJson({
      'subreddit': subreddit,
      'title': title,
      'selftext': selftext,
      'url': url,
      'nsfw': nsfw,
      'spoiler': spoiler,
      'id': '87sf456f',
    });
  }

  Future<List<Message>> inboxMessages() async {
    _log.info('inboxMessages()');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await File('data/inbox.messages.json').readAsString();

    return (jsonDecode(data) as List<dynamic>)
        .map((v) => Message.fromJson(v))
        .toList();
  }

  Future<void> userBlock(String name) async {
    _log.info('userBlock($name)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return;
  }

  Future<void> userUnblock(String name) async {
    _log.info('userUnblock($name)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return;
  }

  Future<void> submissionReport(String id, String reason) async {
    _log.info('submissionReport($id, $reason)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return;
  }

  Future<void> commentReport(String id, String reason) async {
    _log.info('commentReport($id, $reason)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return;
  }
}
