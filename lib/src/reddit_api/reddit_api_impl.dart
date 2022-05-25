import 'package:draw/draw.dart' as draw;
import 'package:flutter_reddit_prototype/src/reddit_api/rule.dart';
import 'package:quiver/collection.dart';
import 'package:url_launcher/url_launcher.dart';

import '../logging.dart';
import 'credentials.dart';
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
import 'reddit_api.dart';

class DrawCache {
  DrawCache([int size = 1000]) {
    _cache = LruMap(maximumSize: size);
  }

  static final _log = getLogger('DrawCache');
  late final LruMap<String, Object> _cache;

  T set<T extends draw.RedditBase>(String key, T value) {
    _cache[key] = value;
    return value;
  }

  T? get<T extends draw.RedditBase>(String key) {
    // _log.info(_cache.containsKey(key) ?  'hit' : 'miss');
    // return _cache[key] as T?;

    // final value = _cache[key];
    // if (value == null) {
    //   _log.info('miss');
    //   return null;
    // }

    // if (!(value is T)) {
    //   _log.error('type ${value.runtimeType} is not a subtype of type $T?');
    //   return null;
    // }

    // _log.info('hit');
    // return value;
    final value = cast<T?>(_cache[key], null);
    _log.info(value != null ? 'hit' : 'miss');
    return value;
  }

  // Future<T> getOrAsync<T extends draw.RedditBase>(
  //   String key,
  //   Future<T> Function() defaultFn,
  // ) async {
  //   final value = get<T>(key);
  //   if (value != null) {
  //     return value;
  //   }
  //   {
  //     final value = await defaultFn();
  //     return set(key, value);
  //     // return value;
  //   }
  // }
}

// class _DrawCache<T extends draw.RedditBase> {
//   _DrawCache([int size = 1000]) {
//     _cache = LruMap(maximumSize: size);
//   }

//   late final LruMap<String, Object> _cache;

//   void set(String key, Object value) {
//     _cache[key] = value;
//   }

//   T? get(String key) {
//     return _cache[key] as T?;
//   }

//   Future<T> getOrAsync(
//     String key,
//     Future<T> Function() defaultFn,
//   ) async {
//     final value = get(key);
//     if (value != null) {
//       return value;
//     }
//     {
//       final value = await defaultFn();
//       set(key, value);
//       return value;
//     }
//   }
// }

class RedditApiImpl implements RedditApi {
  // RedditApiImpl(this.clientId, this.redirectUri, this.credentials);
  RedditApiImpl(this.clientId, this.auth, this.credentials) {
    if (clientId == '') {
      throw Exception('clientId is empty');
    }
  }

  // TODO: make fields private
  final userAgent = 'Flutter Client';
  final String clientId;
  // final Uri redirectUri;
  final Auth auth;
  final Credentials credentials;

  static final _log = getLogger('RedditApiImpl');

  /// Draw object cache. Only use cached values for actions that unnecessarily fetch objects from the server (e.g. commentLike, commentDislike).
  // final _drawCache = LruMap<String, Object>(maximumSize: 1000);
  final _drawCache = DrawCache();

  Future<draw.Submission> _cachedSubmission(String id) async =>
      // _drawCache.getOrAsync(id, reddit.submission(id: id).populate);
      _drawCache.get(id) ?? await _loadSubmission(id);

  Future<draw.Comment> _cachedComment(String id) async =>
      // _drawCache.getOrAsync(id, reddit.comment(id: id).populate);
      _drawCache.get(id) ?? await _loadComment(id);

  Future<draw.Redditor> _cachedRedditor(String name) async =>
      // _drawCache.getOrAsync(name, reddit.redditor(name).populate);
      _drawCache.get(name) ?? await _loadRedditor(name);

  Future<draw.Subreddit> _cachedSubreddit(String name) async =>
      // _drawCache.getOrAsync(name, reddit.subreddit(name).populate);
      _drawCache.get(name) ?? await _loadSubreddit(name);

  Future<draw.Submission> _loadSubmission(String id) async =>
      // _drawCache.set(id, await reddit.submission(id: id).populate());
      _cacheSubmission(await reddit.submission(id: id).populate());

  Future<draw.Comment> _loadComment(String id) async =>
      _drawCache.set(id, await reddit.comment(id: id).populate());

  Future<draw.Redditor> _loadRedditor(String name) async =>
      _drawCache.set(name, await reddit.redditor(name).populate());

  Future<draw.Subreddit> _loadSubreddit(String name) async =>
      _drawCache.set(name, await reddit.subreddit(name).populate());

  // Stream<draw.UserContent> _cacheSubmissionStream(
  //   Stream<draw.UserContent> s
  // ) {
  //   return s.map((v) {
  //     if (v is draw.Submission) {
  //       _drawCache.set(v.id!, v);
  //     }
  //     if (v is draw.Comment) {
  //       _drawCache.set(v.id!, v);
  //     }
  //     return v;
  //   });
  // }

  draw.Submission _cacheSubmission(draw.Submission v) {
    if (v.id != null) _drawCache.set(v.id!, v);
    return v;
  }

  draw.Reddit? _reddit;
  draw.Reddit get reddit {
    if (_reddit == null) {
      throw Exception('not logged in');
    }
    return _reddit!;
  }

  bool get isLoggedIn => _reddit != null;

  Future<void> logout() async {
    _reddit = null;
    await credentials.delete();
  }

  Future<bool> loginSilently() async {
    if (_reddit != null) {
      return true;
    }

    final credentialsJson = await credentials.read() ?? '';
    if (credentialsJson == '') {
      return false;
    }

    // TODO: replace to restoreInstalledAuthenticatedInstance
    _reddit = draw.Reddit.restoreAuthenticatedInstance(
      credentialsJson,
      clientId: clientId,
      userAgent: userAgent,
      // redirectUri: redirectUri,
    );

    return true;
  }

  Future<void> login() async {
    if (_reddit != null) {
      return;
    }

    // final s = AuthServer(redirectUri);
    // print(auth.redirectUri);
    _reddit = draw.Reddit.createInstalledFlowInstance(
      clientId: clientId,
      userAgent: userAgent,
      redirectUri: auth.redirectUri,
      // redirectUri: redirectUri,
    );

    final authUrl = reddit.auth.url(['*'], 'state');
    launch(authUrl.toString());

    final authCode = await auth.stream.first;
    await reddit.auth.authorize(authCode);

    await credentials.write(reddit.auth.credentials.toJson());
    // await s.close();
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

  // TODO: move outside class
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

  // Future<List<Submission>> front(
  //     {required int limit, required FrontSubType type}) {
  //   final s = reddit.front;
  //   switch (type) {
  //     case FrontSubType.best:
  //       return _parseSubmissionStream(s.best(limit: limit));
  //     case FrontSubType.hot:
  //       return _parseSubmissionStream(s.hot(limit: limit));
  //     case FrontSubType.newest:
  //       return _parseSubmissionStream(s.newest(limit: limit));
  //     case FrontSubType.top:
  //       return _parseSubmissionStream(s.top(limit: limit));
  //     case FrontSubType.rising:
  //       return _parseSubmissionStream(s.rising(limit: limit));
  //     case FrontSubType.controversial:
  //       return _parseSubmissionStream(s.controversial(limit: limit));
  //   }
  // }

  Future<List<Submission>> front({
    required int limit,
    required FrontSubType type,
  }) async {
    // return _parseSubmissionStream(
    //   _front(limit: limit, type: type).cast<draw.Submission>().map((v) {
    //     if (v.id != null) _drawCache.set(v.id!, v);
    //     return v;
    //   }),
    // );

    return (await _front(limit: limit, type: type).toList())
        .whereType<draw.Submission>()
        .map(_cacheSubmission)
        .map(_parseSubmission)
        .whereType<Submission>()
        .toList();
  }

  Stream<draw.UserContent> _front({
    required int limit,
    required FrontSubType type,
  }) {
    final s = reddit.front;
    switch (type) {
      case FrontSubType.best:
        return s.best(limit: limit);
      case FrontSubType.hot:
        return s.hot(limit: limit);
      case FrontSubType.newest:
        return s.newest(limit: limit);
      case FrontSubType.top:
        return s.top(limit: limit);
      case FrontSubType.rising:
        return s.rising(limit: limit);
      case FrontSubType.controversial:
        return s.controversial(limit: limit);
    }
  }

  Future<List<Submission>> popular(
      {required int limit, required SubType type}) {
    return subredditSubmissions('popular', limit: limit, type: type);
  }

  Future<List<Subreddit>> currentUserSubreddits({required int limit}) {
    return _parseSubredditStream(reddit.user.subreddits(limit: limit));
  }

  // Future<List<Submission>> subredditSubmissions(
  //   String name, {
  //   required int limit,
  //   required SubType type,
  // }) {
  //   name = removeSubredditPrefix(name);
  //   final s = reddit.subreddit(name);
  //   switch (type) {
  //     case SubType.hot:
  //       return _parseSubmissionStream(s.hot(limit: limit));
  //     case SubType.newest:
  //       return _parseSubmissionStream(s.newest(limit: limit));
  //     case SubType.top:
  //       return _parseSubmissionStream(s.top(limit: limit));
  //     case SubType.rising:
  //       return _parseSubmissionStream(s.rising(limit: limit));
  //     case SubType.controversial:
  //       return _parseSubmissionStream(s.controversial(limit: limit));
  //   }
  // }

  Future<List<Submission>> subredditSubmissions(
    String name, {
    required int limit,
    required SubType type,
  }) async {
    name = removeSubredditPrefix(name);
    return (await _subredditSubmissions(name, limit: limit, type: type).toList())
        .whereType<draw.Submission>()
        .map(_cacheSubmission)
        .map(_parseSubmission)
        .whereType<Submission>()
        .toList();
  }

  Stream<draw.UserContent> _subredditSubmissions(
    String name, {
    required int limit,
    required SubType type,
  }) {
    // name = removeSubredditPrefix(name);
    final s = reddit.subreddit(name);
    switch (type) {
      case SubType.hot:
        return s.hot(limit: limit);
      case SubType.newest:
        return s.newest(limit: limit);
      case SubType.top:
        return s.top(limit: limit);
      case SubType.rising:
        return s.rising(limit: limit);
      case SubType.controversial:
        return s.controversial(limit: limit);
    }
  }

  

  Future<User> user(String name) async {
    // final redditorRef = await reddit.redditor(name);
    // final redditor = await reddit.redditor(name).populate();
    // _drawCache.set(name, redditor);
    // return User.fromJson(redditor.data! as Map<String, dynamic>);
    return _parseUser(await _loadRedditor(name))!;
  }

  Future<void> userBlock(String name) async {
    final params = {'name': name};
    await reddit.post('/api/block_user/', params);
  }

  Future<void> userUnblock(String name) async {
    // final redditorRef = await reddit.redditor(name);
    // // final redditor = await redditorRef.populate();
    // // return User.fromJson(redditor.data! as Map<String, dynamic>);
    // return redditorRef.unblock();

    // _drawCache[name] ??= await reddit.redditor(name).populate();
    // return (_drawCache[name] as draw.Redditor).unblock();

    // final redditor = await _drawCache.getOrAsync<draw.Redditor>(
    //   name,
    //   reddit.redditor(name).populate,
    // );
    return (await _cachedRedditor(name)).unblock();
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

  Future<void> subredditFavorite(String name) {
    name = removeSubredditPrefix(name);
    return reddit.post(
      '/api/favorite/',
      {
        'make_favorite': 'true',
        'sr_name': name,
        'api_type': 'json',
      },
      objectify: false,
    );
  }

  Future<void> subredditUnfavorite(String name) {
    name = removeSubredditPrefix(name);
    return reddit.post(
      '/api/favorite/',
      {
        'make_favorite': 'false',
        'sr_name': name,
        'api_type': 'json',
      },
      objectify: false,
    );
  }

  // TODO: parse submission
  Future<Submission> submission(String id) async {
    // final subRef = reddit.submission(id: id);
    final submission = await _loadSubmission(id);
    // final submission = await reddit.submission(id: id).populate();
    // _drawCache.set(id, submission);
    final comments = (submission.comments!.comments)
        .map((v) => Comment.fromJson(v as Map<String, dynamic>))
        .toList();
    return Submission.fromJson(submission.data!, comments: comments);
  }

  // TODO: parse subreddit
  Future<Subreddit> subreddit(String name) async {
    name = removeSubredditPrefix(name);
    // final subRef = reddit.subreddit(name);
    // final subreddit = await reddit.subreddit(name).populate();
    // _drawCache.set(name, subreddit);
    return Subreddit.fromJson(
        (await _loadSubreddit(name)).data! as Map<String, dynamic>);
  }

  // Future<String> subredditIcon(String name) async {
  //   name = removeSubredditPrefix(name);
  //   final subRef = reddit.subreddit(name);
  //   final sub = await subRef.populate();
  //   return Subreddit.fromJson(sub.data! as Map<String, dynamic>).communityIcon;
  // }

  Future<void> submissionLike(String id, Like like) async {
    // final s = await reddit.submission(id: id).populate();
    // final submission = await _drawCache.getOrAsync<draw.Submission>(
    //   id,
    //   reddit.submission(id: id).populate,
    // );
    return _like(await _cachedSubmission(id), like);
  }

  Future<void> commentLike(String id, Like like) async {
    // final s = await reddit.comment(id: id).populate();
    // final comment = await _drawCache.getOrAsync<draw.Comment>(
    // id, reddit.comment(id: id).populate);
    return _like(await _cachedComment(id), like);
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
    // final s = await reddit.submission(id: id).populate();
    // final submission = await _drawCache.getOrAsync<draw.Submission>(
    //   id,
    //   reddit.submission(id: id).populate,
    // );
    return (await _cachedSubmission(id)).save();
  }

  Future<void> submissionUnsave(String id) async {
    // final s = await reddit.submission(id: id).populate();
    // final submission = await _drawCache.getOrAsync<draw.Submission>(
    //   id,
    //   reddit.submission(id: id).populate,
    // );
    return (await _cachedSubmission(id)).unsave();
  }

  Future<void> submissionHide(String id) async {
    // final s = await reddit.submission(id: id).populate();
    // final submission = await _drawCache.getOrAsync<draw.Submission>(
    //   id,
    //   reddit.submission(id: id).populate,
    // );
    return (await _cachedSubmission(id)).hide();
  }

  Future<void> submissionUnhide(String id) async {
    // final s = await reddit.submission(id: id).populate();
    // final submission = await _drawCache.getOrAsync<draw.Submission>(
    //   id,
    //   reddit.submission(id: id).populate,
    // );
    return (await _cachedSubmission(id)).unhide();
  }

  Future<void> commentSave(String id) async {
    // final s = await reddit.comment(id: id).populate();
    // final comment = await _drawCache.getOrAsync<draw.Comment>(
    //   id,
    //   reddit.comment(id: id).populate,
    // );
    return (await _cachedComment(id)).save();
  }

  Future<void> commentUnsave(String id) async {
    // final s = await reddit.comment(id: id).populate();
    // final comment = await _drawCache.getOrAsync<draw.Comment>(
    //   id,
    //   reddit.comment(id: id).populate,
    // );
    return (await _cachedComment(id)).unsave();
  }

  Future<User?> currentUser() async {
    final redditor = await reddit.user.me();
    if (redditor == null) {
      return null;
    }
    _drawCache.set(redditor.displayName, redditor);
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
    // final subRef = reddit.submission(id: id);
    // final sub = await subRef.populate();
    // final submission = await _drawCache.getOrAsync<draw.Submission>(
    //   id,
    //   reddit.submission(id: id).populate,
    // );
    final comment = await (await _cachedSubmission(id)).reply(body);
    return _parseComment(comment)!;
  }

  Future<void> submissionReport(String id, String reason) async {
    // final subRef = reddit.submission(id: id);
    // final sub = await subRef.populate();
    // final submission = await _drawCache.getOrAsync<draw.Submission>(
    //   id,
    //   reddit.submission(id: id).populate,
    // );
    return (await _cachedSubmission(id)).report(reason);
    // final comment = await sub.reply(body);
    // return _parseComment(comment)!;
  }

  Future<void> commentReport(String id, String reason) async {
    // final commentRef = reddit.comment(id: id);
    // final comment = await commentRef.populate();
    // final comment = await _drawCache.getOrAsync<draw.Comment>(
    //   id,
    //   reddit.comment(id: id).populate,
    // );
    return (await _cachedComment(id)).report(reason);
  }

  Future<Comment> commentReply(String id, String body) async {
    // final commentRef = reddit.comment(id: id);
    // final comment = await commentRef.populate();
    // final comment = await _drawCache.getOrAsync<draw.Comment>(
    //   id,
    //   reddit.comment(id: id).populate,
    // );
    final commentReply = await (await _cachedComment(id)).reply(body);
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

  Future<List<Rule>> subredditRules(String name) async {
    name = removeSubredditPrefix(name);
    final resp = await reddit.get('/r/$name/about/rules', objectify: false);
    return parseRules(resp)!;
  }
}
