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

// TODO: rename commentSave -> saveComment
abstract class RedditApi {
  Stream<Submission> front({required int limit, required FrontSubType type});
  Stream<Submission> popular({required int limit, required SubType type});

  Future<Subreddit> subreddit(String name);
  // Future<String> subredditIcon(String name);

  Future<User> user(String name);
  Stream<Comment> userComments(String name, {required int limit});
  Stream<Submission> userSubmissions(String name, {required int limit});
  Future<List<Trophy>> userTrophies(String name);
  Future<UserSaved> userSaved(String name, {required int limit});

  Future<void> subredditSubscribe(String name);
  Future<void> subredditUnsubscribe(String name);
  Future<void> subredditFavorite(String name);
  Future<void> subredditUnfavorite(String name);
  Stream<Submission> subredditSubmissions(
    String name, {
    required int limit,
    required SubType type,
  });

  Future<Submission> submission(String id);
  Future<void> submissionLike(String id, Like like);
  Future<void> submissionSave(String id);
  Future<void> submissionUnsave(String id);
  Future<Comment> submissionReply(String id, String body);

  Future<void> commentLike(String id, Like like);
  Future<void> commentSave(String id);
  Future<void> commentUnsave(String id);
  Future<Comment> commentReply(String id, String body);

  Future<User?> currentUser();
  Stream<Subreddit> currentUserSubreddits({required int limit});

  Stream<Submission> search(
    String query, {
    required int limit,
    required Sort sort,
    String subreddit = 'all',
  });
  Stream<Subreddit> searchSubreddits(String query, {required int limit});
  Stream<Subreddit> searchSubredditsByName(String query);

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

  Stream<Message> inboxMessages();
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

  Stream<Submission> _submissionsStream(Stream<draw.UserContent> s) async* {
    await for (final v in s) {
      // final dsub = cast<draw.Submission?>(v, null);
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

      try {
        yield Submission.fromJson(
          (v as draw.Submission).data as Map<String, dynamic>,
        );
      } on TypeError catch (_) {
        _log.warning('fail to parse Submission: $v');
        continue;
      } on Exception catch (_) {
        _log.warning('fail to parse Submission: $v');
        continue;
      }
    }
  }

  Stream<Subreddit> _subredditStream(Stream<draw.Subreddit> s) async* {
    await for (final v in s) {
      try {
        yield Subreddit.fromJson(v.data! as Map<String, dynamic>);
      } on TypeError catch (_) {
        _log.warning('fail to parse Subreddit: $v');
        continue;
      } on Exception catch (_) {
        _log.warning('fail to parse Subreddit: $v');
        continue;
      }
    }
  }

  Stream<Comment> _commentsStream(Stream<draw.UserContent> s) async* {
    await for (final v in s) {
      try {
        yield Comment.fromJson(
          (v as draw.Comment).data! as Map<String, dynamic>,
        );
      } on TypeError catch (_) {
        _log.warning('fail to parse Comment: $v');
        continue;
      } on Exception catch (_) {
        _log.warning('fail to parse Comment: $v');
        continue;
      }
    }
  }

  Stream<Submission> front({required int limit, required FrontSubType type}) {
    final s = reddit.front;
    switch (type) {
      case FrontSubType.best:
        return _submissionsStream(s.best(limit: limit));
      case FrontSubType.hot:
        return _submissionsStream(s.hot(limit: limit));
      case FrontSubType.newest:
        return _submissionsStream(s.newest(limit: limit));
      case FrontSubType.top:
        return _submissionsStream(s.top(limit: limit));
      case FrontSubType.rising:
        return _submissionsStream(s.rising(limit: limit));
      case FrontSubType.controversial:
        return _submissionsStream(s.controversial(limit: limit));
    }
  }

  Stream<Submission> popular({required int limit, required SubType type}) {
    return subredditSubmissions('popular', limit: limit, type: type);
  }

  Stream<Subreddit> currentUserSubreddits({required int limit}) {
    // await for (final v in reddit.user.subreddits(limit: limit)) {
    //   // if (v.data == null) {
    //   //   _log.warning('draw.Subreddit.data is empty: $v');
    //   //   continue;
    //   // }
    //   // final sub = Subreddit.fromJson(v.data! as Map<String, dynamic>);
    //   // yield sub;

    //   try {
    //     yield Subreddit.fromJson(v.data! as Map<String, dynamic>);
    //   } on TypeError catch (_) {
    //     _log.warning('fail to parse Subreddit: $v');
    //     continue;
    //   } on Exception catch (_) {
    //     _log.warning('fail to parse Subreddit: $v');
    //     continue;
    //   }
    // }
    return _subredditStream(reddit.user.subreddits(limit: limit));
  }

  Stream<Submission> subredditSubmissions(
    String name, {
    required int limit,
    required SubType type,
  }) {
    name = removeSubredditPrefix(name);
    final s = reddit.subreddit(name);
    switch (type) {
      case SubType.hot:
        return _submissionsStream(s.hot(limit: limit));
      case SubType.newest:
        return _submissionsStream(s.newest(limit: limit));
      case SubType.top:
        return _submissionsStream(s.top(limit: limit));
      case SubType.rising:
        return _submissionsStream(s.rising(limit: limit));
      case SubType.controversial:
        return _submissionsStream(s.controversial(limit: limit));
    }
  }

  Future<User> user(String name) async {
    final redditorRef = await reddit.redditor(name);
    final redditor = await redditorRef.populate();
    return User.fromJson(redditor.data! as Map<String, dynamic>);
  }

  // TODO: MAYBE: add type support
  Stream<Comment> userComments(
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
    return _commentsStream(reddit.redditor(name).comments.newest(limit: limit));
  }

// TODO: MAYBE: add type support
  Stream<Submission> userSubmissions(String name, {required int limit}) {
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
    return _submissionsStream(
        reddit.redditor(name).submissions.newest(limit: limit));
  }

  Future<List<Trophy>> userTrophies(String name) async {
    final drawTrophies = await reddit.redditor('foo').trophies();
    final trophies = <Trophy>[];
    for (final v in drawTrophies) {
      // if (trophy.data == null) {
      //   _log.warning('draw.Trophy.data is empty: $trophy');
      //   continue;
      // }
      // trophies.add(Trophy.fromJson(trophy.data! as Map<String, dynamic>));
      try {
        trophies.add(Trophy.fromJson(v.data! as Map<String, dynamic>));
      } on TypeError catch (_) {
        _log.warning('fail to parse Trophy: $v');
        continue;
      } on Exception catch (_) {
        _log.warning('fail to parse Trophy: $v');
        continue;
      }
    }
    return trophies;
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

  // TODO: use draw.Submission instead id for optimisation
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
          submissions.add(Submission.fromJson(v.data! as Map<String, dynamic>));
        else if (v is draw.Comment)
          comments.add(Comment.fromJson(v.data! as Map<String, dynamic>));
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

  Stream<Submission> search(
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
    return _submissionsStream(
        reddit.subreddit(subreddit).search(query, params: params));
  }

  Stream<Subreddit> searchSubreddits(String query, {required int limit}) {
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
    return _subredditStream(reddit.subreddits
        .search(query, limit: limit)
        .map((v) => v as draw.Subreddit));
  }

  Stream<Subreddit> searchSubredditsByName(
    String query,
  ) async* {
    for (final v in await reddit.subreddits.searchByName(query)) {
      final dsub = cast<draw.Subreddit?>(v, null);
      if (dsub == null) {
        _log.warning('not draw.Subreddit: $v');
        continue;
      }
      if (dsub.data == null) {
        _log.warning('draw.Subreddit.data is empty: $v');
        continue;
      }
      yield Subreddit.fromJson(dsub.data! as Map<String, dynamic>);
    }
    // return _subredditStream(reddit.subreddits.searchByName(query));
  }

  Future<Comment> submissionReply(String id, String body) async {
    final subRef = reddit.submission(id: id);
    final sub = await subRef.populate();
    final comment = await sub.reply(body);
    return Comment.fromJson(comment.data! as Map<String, dynamic>);
  }

  Future<Comment> commentReply(String id, String body) async {
    final commentRef = reddit.comment(id: id);
    final comment = await commentRef.populate();
    final commentReply = await comment.reply(body);
    return Comment.fromJson(commentReply.data! as Map<String, dynamic>);
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
    return Submission.fromJson(sub.data! as Map<String, dynamic>);
  }

  Stream<Message> inboxMessages() async* {
    await for (final v in reddit.inbox.messages()) {
      final dsub = cast<draw.Message?>(v, null);
      if (dsub == null) {
        _log.warning('not draw.Subreddit: $v');
        continue;
      }
      if (dsub.data == null) {
        _log.warning('draw.Subreddit.data is empty: $v');
        continue;
      }
      yield Message.fromJson(dsub.data! as Map<String, dynamic>);
    }
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

  Stream<Submission> front({
    required int limit,
    required FrontSubType type,
  }) async* {
    _log.info('front($limit, $type)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await File('data/user.front.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => _addType(v, type))
        .map((v) => Submission.fromJson(v))
        .take(limit);

    for (final item in items) {
      yield item;
    }
  }

  Random _random = Random(42);

  Stream<Submission> popular({
    required int limit,
    required SubType type,
  }) async* {
    _log.info('popular($limit, $type)');
    await Future.delayed(_delay);

    _mustLoggedIn();
    final data = await File('data/popular.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => _addType(v, type))
        .map((v) => Submission.fromJson(v))
        .take(limit);

    for (final item in items) {
      yield item;
    }
  }

  @override
  Stream<Subreddit> currentUserSubreddits({required int limit}) async* {
    _log.info('currentUserSubreddits($limit)');
    await Future.delayed(_delay);
    _mustLoggedIn();

    final data = await File('data/user.subreddits.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => Subreddit.fromJson(v))
        .take(limit);

    for (final item in items) {
      yield item;
    }
  }

  Stream<Submission> subredditSubmissions(
    String name, {
    required int limit,
    required SubType type,
  }) async* {
    _log.info('subredditSubmissions($name, $limit, $type)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    name = removeSubredditPrefix(name);

    final data = await File('data/subreddit.submissions.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => _addType(v, type))
        .map((v) => Submission.fromJson(v))
        .take(limit);

    for (final item in items) {
      yield item;
    }
  }

  Future<User> user(String name) async {
    _log.info('user($name)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await File('data/user.info.json').readAsString();
    return User.fromJson(jsonDecode(data));
  }

  Stream<Comment> userComments(String name, {required int limit}) async* {
    _log.info('userComments($name, $limit)');
    await Future.delayed(_delay);
    _mustLoggedIn();

    final data = await File('data/user.comments.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => Comment.fromJson(v))
        .take(limit);

    for (final item in items) {
      yield item;
    }
  }

  Stream<Submission> userSubmissions(String name, {required int limit}) async* {
    _log.info('userSubmissions($name, $limit)');
    await Future.delayed(_delay);
    _mustLoggedIn();

    final data = await File('data/user.submissions.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => Submission.fromJson(v))
        .take(limit);

    for (final item in items) {
      yield item;
    }
  }

  Future<List<Trophy>> userTrophies(String name) async {
    _log.info('userTrophies($name)');
    await Future.delayed(_delay);
    _mustLoggedIn();

    final data = await File('data/user.trophies.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => Trophy.fromJson(v));

    return items.toList();
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
    final data = await File('data/subreddit.json').readAsString();
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

  Stream<Submission> search(
    String query, {
    required int limit,
    required Sort sort,
    String subreddit = 'all',
  }) async* {
    _log.info('search($query, $limit, $sort, $subreddit)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    subreddit = removeSubredditPrefix(subreddit);
    final data = await File('data/search.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => _addType(v, sort))
        .map((v) => Submission.fromJson(v))
        .take(limit);

    for (final item in items) {
      yield item;
    }
  }

  Stream<Subreddit> searchSubreddits(
    String query, {
    required int limit,
  }) async* {
    _log.info('searchSubreddits($query, $limit)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await File('data/subreddits.search.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => Subreddit.fromJson(v))
        .take(limit);

    for (final item in items) {
      yield item;
    }
  }

  Stream<Subreddit> searchSubredditsByName(String query) async* {
    _log.info('searchSubredditsByName($query)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data =
        await File('data/subreddits.search.by.name.json').readAsString();

    final items =
        (jsonDecode(data) as List<dynamic>).map((v) => Subreddit.fromJson(v));

    for (final item in items) {
      yield item;
    }
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

  Stream<Message> inboxMessages() async* {
    _log.info('inboxMessages()');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await File('data/inbox.messages.json').readAsString();

    final items =
        (jsonDecode(data) as List<dynamic>).map((v) => Message.fromJson(v));

    for (final item in items) {
      yield item;
    }
  }
}
