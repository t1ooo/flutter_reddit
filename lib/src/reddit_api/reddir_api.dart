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
import 'vote.dart';

// abstract class RedditApi {
//   Future<List<Submission>> front({required int limit});
//   Future<List<Submission>> popular({required int limit});
//   Future<List<Subreddit>> currentUserSubreddits({required int limit});
// }

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

  Stream<Submission> subredditSubmissions(
    String name, {
    required int limit,
    required SubType type,
  });

  Future<Subreddit> subreddit(String name);
  Future<String> subredditIcon(String name);

  Future<User> user(String name);
  Stream<Comment> userComments(String name, {required int limit});
  Stream<Submission> userSubmissions(String name, {required int limit});
  Future<List<Trophy>> userTrophies(String name);
  // Future<Submission> submission(String id);
  // Stream<Comment> submissionComments(String name, {required int limit});

  Future<void> subscribe(String name);
  Future<void> unsubscribe(String name);

  Future<void> subredditFavorite(String name);

  Future<void> subredditUnfavorite(String name);

  Future<Submission> submission(String id);

  Future<void> submissionVote(String id, Vote vote);
  Future<void> commentVote(String id, Vote vote);

  Future<void> submissionSave(String id);
  Future<void> submissionUnsave(String id);

  Future<void> commentSave(String id);
  Future<void> commentUnsave(String id);

  Future<User?> currentUser();
  Stream<Subreddit> currentUserSubreddits({required int limit});

  /// return List<Submission|Comment>
  // Stream<dynamic> currentUserSaved();
  // Stream<Submission> currentUserSavedSubmissions({required int limit});
  // Stream<Comment> currentUserSavedComments({required int limit});

  // Stream<Submission> userSavedSubmissions(String name, {required int limit});
  // Stream<Comment> userSavedComments(String name, {required int limit});
  Future<UserSaved> userSaved(String name, {required int limit});

  Stream<Submission> search(
    String query, {
    required int limit,
    required Sort sort,
    String subreddit = 'all',
  });

  // Search subreddits by title and description.
  Stream<Subreddit> searchSubreddits(String query, {required int limit});

  // Search subreddits by title
  Stream<Subreddit> searchSubredditsByName(String query);

  // Future<String> userIcon(String name);

  Future<Comment> submissionReply(String id, String body);
  Future<Comment> commentReply(String id, String body);

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

  // Future<bool> isLoggedIn();
  bool get isLoggedIn;
  Future<bool> loginSilently();
  Future<void> login();
  Future<void> logout();

  Stream<Message> inboxMessages();
}

class RedditApiImpl implements RedditApi {
  RedditApiImpl(this.clientId, this.redirectUri, this.credentials);

  // final file = File('credentials.json');
  final userAgent = 'Flutter Client';

  // bool _isLoggedIn = false;

  // Future<bool> isLoggedIn() async => _isLoggedIn;
  // Future<bool> isLoggedIn() async => _reddit != null;
  bool get isLoggedIn => _reddit != null;

  // Future<bool> isLoggedIn() async {
  //   try {
  //     final redditor = await reddit.user.me();
  //     return redditor != null;
  //   } on Exception catch (e) {
  //     _log.info('', e);
  //   }
  //   return false;
  // }

  // Future<void> login() {
  //   return _auth();
  // }

  // Future<bool> loginSilently() {
  //   return _authSilently();
  // }

  Future<void> logout() async {
    _reddit = null;
    await credentials.delete();
  }

  // Future<bool> login() async {
  //   await loginSilently();
  //   await loginOauth();
  // }

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

  // Future<String> _credentialsPath() async {
  //   return (await getTemporaryDirectory()).path + '/credentials.json';
  // }

  // Future<void> _auth() async {
  //   if (_reddit != null) {
  //     return;
  //   }

  //   final credentialsJson =
  //       await file.exists() ? await file.readAsString() : '';

  //   draw.Reddit reddit;
  //   if (credentialsJson == '') {
  //     print('login');

  //     final s = AuthServer(redirectUri);

  //     reddit = draw.Reddit.createInstalledFlowInstance(
  //       clientId: clientId,
  //       userAgent: userAgent,
  //       redirectUri: redirectUri,
  //     );

  //     final authUrl = reddit.auth.url(['*'], 'state');
  //     launch(authUrl.toString());

  //     final authCode = await s.stream.first;
  //     await reddit.auth.authorize(authCode);

  //     await file.writeAsString(reddit.auth.credentials.toJson());

  //     await s.close();
  //   } else {
  //     print('cached');
  //     reddit = draw.Reddit.restoreAuthenticatedInstance(
  //       credentialsJson,
  //       clientId: clientId,
  //       userAgent: userAgent,
  //       redirectUri: redirectUri,
  //     );
  //   }

  //   _reddit = reddit;
  // }

  final String clientId;
  // final String userAgent = 'Flutter Client';
  final Uri redirectUri;
  final Credentials credentials;
  // final draw.Reddit reddit;
  static final _log = getLogger('RedditApiImpl');

  draw.Reddit? _reddit;
  draw.Reddit get reddit {
    if (_reddit == null) {
      throw Exception('not logged in');
    }
    return _reddit!;
  }

  Stream<Submission> _submissionsStream(
    Stream<draw.UserContent> s,
    // SubType type,
  ) async* {
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
      // final sub = Submission.fromJson(dsub.data!, type: type);
      final sub = Submission.fromJson(dsub.data!);
      yield sub;
    }
  }

  // Stream<Submission> _submissions(draw.BaseListingMixin s, {required int limit, required SubType type}) {
  // switch (type) {
  //     case SubType.best:
  //       return _submissionsStream(s.best(limit: limit), SubType.best);
  //     case SubType.hot:
  //       return _submissionsStream(s.hot(limit: limit), SubType.hot);
  //     case SubType.newest:
  //       return _submissionsStream(s.newest(limit: limit), SubType.newest);
  //     case SubType.top:
  //       return _submissionsStream(s.top(limit: limit), SubType.top);
  //     case SubType.rising:
  //       return _submissionsStream(s.rising(limit: limit), SubType.rising);
  //     case SubType.controversial:
  //       return _submissionsStream(
  //           s.controversial(limit: limit), SubType.controversial);
  //   }
  // }

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
    // final s = reddit.subreddit('popular');
    // switch (type) {
    //   // case SubType.best:
    //   // TODO: find a solution without exception
    //   // throw Exception('unsupported type: $type');
    //   case SubType.hot:
    //     return _submissionsStream(s.hot(limit: limit));
    //   case SubType.newest:
    //     return _submissionsStream(s.newest(limit: limit));
    //   case SubType.top:
    //     return _submissionsStream(s.top(limit: limit));
    //   case SubType.rising:
    //     return _submissionsStream(s.rising(limit: limit));
    //   case SubType.controversial:
    //     return _submissionsStream(s.controversial(limit: limit));
    // }
    return subredditSubmissions('popular', limit: limit, type: type);
  }

  Stream<Subreddit> currentUserSubreddits({required int limit}) async* {
    // reddit.subreddits;
    await for (final v in reddit.user.subreddits(limit: limit)) {
      if (v.data == null) {
        _log.warning('draw.Subreddit.data is empty: $v');
        continue;
      }
      final sub = Subreddit.fromJson(v.data!);
      yield sub;
    }
  }

  Stream<Submission> subredditSubmissions(
    String name, {
    required int limit,
    required SubType type,
  }) {
    name = removeSubredditPrefix(name);
    final s = reddit.subreddit(name);
    switch (type) {
      // case SubType.best:
      // TODO: find a solution without exception
      // throw Exception('unsupported type: $type');
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
    return User.fromJson(redditor.data!);
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
      final sub = Comment.fromJson(dsub.data!);
      yield sub;
    }
  }

// TODO: MAYBE: add type support
  Stream<Submission> userSubmissions(String name, {required int limit}) async* {
    await for (final v
        in reddit.redditor(name).submissions.newest(limit: limit)) {
      final dsub = cast<draw.Comment?>(v, null);
      if (dsub == null) {
        _log.warning('not draw.Submission: $v');
        continue;
      }
      if (dsub.data == null) {
        _log.warning('draw.Submission.data is empty: $v');
        continue;
      }
      final sub = Submission.fromJson(dsub.data!);
      yield sub;
    }
  }

  Future<List<Trophy>> userTrophies(String name) async {
    final drawTrophies = await reddit.redditor('foo').trophies();
    final trophies = <Trophy>[];
    for (final trophy in drawTrophies) {
      if (trophy.data == null) {
        _log.warning('draw.Trophy.data is empty: $trophy');
        continue;
      }
      trophies.add(Trophy.fromJson(trophy.data!));
    }
    return trophies;
  }

  // TODO: rename to subredditSubscribe
  Future<void> subscribe(String name) {
    name = removeSubredditPrefix(name);
    return reddit.subreddit(name).subscribe();
  }

  Future<void> unsubscribe(String name) {
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
        .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => Comment.fromJson(v))
        .toList();
    // return Submission.fromJson(sub.data!, comments: sub.comments!.comments);
    return Submission.fromJson(sub.data!, comments: comments);
  }

  Future<Subreddit> subreddit(String name) async {
    name = removeSubredditPrefix(name);
    final subRef = reddit.subreddit(name);
    final sub = await subRef.populate();
    return Subreddit.fromJson(sub.data!);
  }

  Future<String> subredditIcon(String name) async {
    name = removeSubredditPrefix(name);
    final subRef = reddit.subreddit(name);
    final sub = await subRef.populate();
    return Subreddit.fromJson(sub.data!).communityIcon;
  }

  // Future<String> userIcon(String name) async {
  //   final redditorRef = await reddit.redditor(name);
  //   final redditor = await redditorRef.populate();
  //   return User.fromJson(redditor.data!).iconImg;
  // }

  // TODO: use draw.Submission instead id for optimisation
  Future<void> submissionVote(String id, Vote vote) async {
    final s = await reddit.submission(id: id).populate();
    return _vote(s, vote);
  }

  Future<void> commentVote(String id, Vote vote) async {
    final s = await reddit.comment(id: id).populate();
    return _vote(s, vote);
  }

  Future<void> _vote(draw.VoteableMixin s, Vote vote) async {
    switch (vote) {
      case Vote.none:
        return s.clearVote();
      case Vote.up:
        return s.upvote();
      case Vote.down:
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

  Future<User?> currentUser() async {
    final redditor = await reddit.user.me();
    if (redditor == null) {
      return null;
    }
    return User.fromJson(redditor.data!);
  }

  Future<UserSaved> userSaved(String name, {required int limit}) async {
    //  for(final v in await user!.saved().toList()) {
    // if (v is Submission) print('Submission ${v.id}');
    // if (v is CommentRef) print('CommentRef');
    // if (v is Comment) print('Comment ${v.id}');
    // final redditor = await reddit.user.me();
    // if (redditor == null) {
    //   return;
    // }

    final redditorRef = reddit.redditor(name);
    // final redditor = await redditorRef.populate();
    final submissions = <Submission>[];
    final comments = <Comment>[];
    await for (final v in redditorRef.saved(limit: limit)) {
      try {
        if (v is draw.Submission)
          submissions.add(Submission.fromJson(v.data!));
        else if (v is draw.Comment)
          comments.add(Comment.fromJson(v.data!));
        else
          _log.warning('undefined type');
      } on Exception catch (e, st) {
        _log.error('', e, st);
      }
    }

    return UserSaved(submissions, comments);
  }

  // Stream<Submission> userSavedSubmissions(String name, {required int limit}) {
  //   return currentUserSaved(limit)
  //       .where((v) => v is Submission)
  //       .map((v) => v as Submission);
  // }

  // Stream<Comment> userSavedComments(String name, {required int limit}) {
  //   return currentUserSaved(limit)
  //       .where((v) => v is Comment)
  //       .map((v) => v as Comment);
  // }

  Stream<Submission> search(
    String query, {
    required int limit,
    required Sort sort,
    String subreddit = 'all',
  }) async* {
    // reddit.subreddits.search();
    subreddit = removeSubredditPrefix(subreddit);
    final params = {'limit': limit.toString()};
    await for (final v
        in reddit.subreddit(subreddit).search(query, params: params)) {
      final dsub = cast<draw.Submission?>(v, null);
      if (dsub == null) {
        _log.warning('not draw.Submission: $v');
        continue;
      }
      if (dsub.data == null) {
        _log.warning('draw.Submission.data is empty: $v');
        continue;
      }
      yield Submission.fromJson(dsub.data!);
    }
  }

  Stream<Subreddit> searchSubreddits(String query,
      {required int limit}) async* {
    await for (final v in reddit.subreddits.search(query, limit: limit)) {
      final dsub = cast<draw.Subreddit?>(v, null);
      if (dsub == null) {
        _log.warning('not draw.Subreddit: $v');
        continue;
      }
      if (dsub.data == null) {
        _log.warning('draw.Subreddit.data is empty: $v');
        continue;
      }
      yield Subreddit.fromJson(dsub.data!);
    }
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
      yield Subreddit.fromJson(dsub.data!);
    }
  }

  Future<Comment> submissionReply(String id, String body) async {
    final subRef = reddit.submission(id: id);
    final sub = await subRef.populate();
    final comment = await sub.reply(body);
    return Comment.fromJson(comment.data!);
  }

  Future<Comment> commentReply(String id, String body) async {
    final commentRef = reddit.comment(id: id);
    final comment = await commentRef.populate();
    final commentReply = await comment.reply(body);
    return Comment.fromJson(commentReply.data!);
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
    return Submission.fromJson(sub.data!);
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
      yield Message.fromJson(dsub.data!);
    }
  }
}

class FakeRedditApi implements RedditApi {
  FakeRedditApi();

  static final _log = getLogger('FakeRedditApi');

  Duration _delay = Duration(seconds: 1 ~/ 10);

  Map _addType(Map v, Enum type) {
    v['title'] = '$type: ${v['title']}';
    return v;
  }

  Stream<Submission> front({
    required int limit,
    required FrontSubType type,
  }) async* {
    _log.info('front($limit, $type)');
    _mustLoggedIn();
    final data = await File('data/user.front.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        // .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => _addType(v, type))
        .map((v) => Submission.fromJson(v))
        .take(limit);

    for (final item in items) {
      await Future.delayed(_delay);
      yield item;
    }
  }

  Random _random = Random(42);

  Stream<Submission> popular({
    required int limit,
    required SubType type,
  }) async* {
    _log.info('popular($limit, $type)');
    _mustLoggedIn();
    final data = await File('data/popular.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        // .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => _addType(v, type))
        .map((v) => Submission.fromJson(v))
        .take(limit);

    for (final item in items) {
      await Future.delayed(_delay);
      yield item;
    }
  }

  @override
  Stream<Subreddit> currentUserSubreddits({required int limit}) async* {
    _log.info('currentUserSubreddits($limit)');
    _mustLoggedIn();

    final data = await File('data/user.subreddits.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        // .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => Subreddit.fromJson(v))
        .take(limit);

    for (final item in items) {
      await Future.delayed(_delay);
      yield item;
    }
  }

  Stream<Submission> subredditSubmissions(
    String name, {
    required int limit,
    required SubType type,
  }) async* {
    _log.info('subredditSubmissions($name, $limit, $type)');
    _mustLoggedIn();
    name = removeSubredditPrefix(name);

    final data = await File('data/subreddit.submissions.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        // .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => _addType(v, type))
        .map((v) => Submission.fromJson(v))
        .take(limit);

    for (final item in items) {
      await Future.delayed(_delay);
      yield item;
    }
  }

  Future<User> user(String name) async {
    _log.info('user($name)');
    _mustLoggedIn();
    final data = await File('data/user.info.json').readAsString();
    return User.fromJson(jsonDecode(data));
  }

  Stream<Comment> userComments(String name, {required int limit}) async* {
    _log.info('userComments($name, $limit)');
    _mustLoggedIn();

    final data = await File('data/user.comments.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => Comment.fromJson(v))
        .take(limit);

    for (final item in items) {
      await Future.delayed(_delay);
      yield item;
    }
  }

  Stream<Submission> userSubmissions(String name, {required int limit}) async* {
    _log.info('userSubmissions($name, $limit)');
    _mustLoggedIn();

    final data = await File('data/user.submissions.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        // .map((v) => v as Map<dynamic, dynamic>)
        // .map((v) => Submission.fromJson(v, type: SubType.hot))
        .map((v) => Submission.fromJson(v))
        .take(limit);

    for (final item in items) {
      await Future.delayed(_delay);
      yield item;
    }
  }

  Future<List<Trophy>> userTrophies(String name) async {
    _log.info('userTrophies($name)');
    _mustLoggedIn();

    await Future.delayed(_delay);
    final data = await File('data/user.trophies.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => Trophy.fromJson(v));

    return items.toList();
  }

  Future<void> subscribe(String name) async {
    _log.info('subscribe($name)');
    _mustLoggedIn();
    name = removeSubredditPrefix(name);
    await Future.delayed(_delay);
    return;
  }

  Future<void> unsubscribe(String name) async {
    _log.info('unsubscribe($name)');
    _mustLoggedIn();
    name = removeSubredditPrefix(name);
    await Future.delayed(_delay);
    return;
  }

  Future<void> subredditFavorite(String name) async {
    _log.info('subredditFavorite($name)');
    return;
  }

  Future<void> subredditUnfavorite(String name) async {
    _log.info('subredditUnfavorite($name)');
    return;
  }

  Future<Submission> submission(String id) async {
    _log.info('submission($id)');
    _mustLoggedIn();
    await Future.delayed(_delay);

    final subData = await File('data/submission.json').readAsString();
    final comData = await File('data/submission.comments.json').readAsString();

    // try {
    final comments = (jsonDecode(comData) as List<dynamic>)
        .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => Comment.fromJson(v))
        .toList();

    // print(comments);
    return Submission.fromJson(
      jsonDecode(subData) as Map,
      comments: comments,
    );
    // } catch (e, st) {
    // print(e);
    // print(st);
    // }

    // return placeholderSubmission();

    //     .map((v) => Trophy.fromJson(v));

    // final items = (jsonDecode(data) as List<dynamic>)
    //     .map((v) => v as Map<dynamic, dynamic>)
    //     .map((v) => Trophy.fromJson(v));
  }

  Future<Subreddit> subreddit(String name) async {
    _log.info('subreddit($name)');
    _mustLoggedIn();
    name = removeSubredditPrefix(name);
    final data = await File('data/subreddit.json').readAsString();
    final map = jsonDecode(data) as Map;
    map['user_is_subscriber'] = _random.nextInt(1000) % 2 == 0;
    return Subreddit.fromJson(map);
  }

  Future<void> submissionVote(String id, Vote vote) async {
    _log.info('submissionVote($id, $vote)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return;
  }

  @override
  Future<void> commentVote(String id, Vote vote) async {
    _log.info('commentVote($id, $vote)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return;
  }

  Future<void> submissionSave(String id) async {
    _log.info('submissionSave($id)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return;
  }

  Future<void> submissionUnsave(String id) async {
    _log.info('submissionUnsave($id)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return;
  }

  Future<void> commentSave(String id) async {
    _log.info('commentSave($id)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return;
  }

  Future<void> commentUnsave(String id) async {
    _log.info('commentUnsave($id)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return;
  }

  Future<User?> currentUser() async {
    _log.info('currentUser()');
    _mustLoggedIn();
    final data = await File('data/user.current.info.json').readAsString();
    return User.fromJson(jsonDecode(data));
  }

  Future<UserSaved> userSaved(String name, {required int limit}) async {
    _log.info('userSaved($name, $limit)');
    _mustLoggedIn();
    final data = await File('data/user.current.saved.json').readAsString();
    final submissions = <Submission>[];
    final comments = <Comment>[];

    final items = (jsonDecode(data) as List<dynamic>)
        .take(limit)
        .map((v) => v as Map<dynamic, dynamic>)
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

  // Stream<Submission> currentUserSavedSubmissions({required int limit}) {
  //   return _currentUserSaved(limit)
  //       .where((v) => v is Submission)
  //       .map((v) => v as Submission)
  //       .take(limit);
  // }

  // Stream<Comment> currentUserSavedComments({required int limit}) {
  //   return _currentUserSaved(limit)
  //       .where((v) => v is Comment)
  //       .map((v) => v as Comment)
  //       .take(limit);
  // }

  Future<String> subredditIcon(String name) async {
    _log.info('subredditIcon($name)');
    _mustLoggedIn();
    name = removeSubredditPrefix(name);
    await Future.delayed(_delay);
    return 'https://styles.redditmedia.com/t5_2ql8s/styles/communityIcon_42dkzkktri741.png?width=256&s=be327c0205feb19fef8a00fe88e53683b2f81adf';
  }

  // Future<String> userIcon(String name) async {
  //   await Future.delayed(_delay);
  //   return 'https://styles.redditmedia.com/t5_27o1ou/styles/profileIcon_snoo1bb735c3-8e35-4cf7-86db-61a16e425270-headshot.png?width=256&height=256&crop=256:256,smart&s=b2b6b0dbdc33478836366f4b75a132c734d19126';
  // }

  Stream<Submission> search(
    String query, {
    required int limit,
    required Sort sort,
    String subreddit = 'all',
  }) async* {
    _log.info('search($query, $limit, $sort, $subreddit)');
    _mustLoggedIn();
    subreddit = removeSubredditPrefix(subreddit);
    final data = await File('data/search.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        // .map((v) => v as Map<dynamic, dynamic>)
        .map((v) => _addType(v, sort))
        // .map((v) => Submission.fromJson(v, type: SubType.hot))
        .map((v) => Submission.fromJson(v))
        .take(limit);

    for (final item in items) {
      await Future.delayed(_delay);
      yield item;
    }
  }

  Stream<Subreddit> searchSubreddits(
    String query, {
    required int limit,
  }) async* {
    _log.info('searchSubreddits($query, $limit)');
    _mustLoggedIn();
    final data = await File('data/subreddits.search.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        // .map((v) => v as Map<dynamic, dynamic>)
        // .map((v) => _addType(v, sort))
        // .map((v) => Submission.fromJson(v, type: SubType.hot))
        .map((v) => Subreddit.fromJson(v))
        .take(limit);

    for (final item in items) {
      await Future.delayed(_delay);
      yield item;
    }
  }

  Stream<Subreddit> searchSubredditsByName(String query) async* {
    _log.info('searchSubredditsByName($query)');
    _mustLoggedIn();
    final data =
        await File('data/subreddits.search.by.name.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        // .map((v) => v as Map<dynamic, dynamic>)
        // .map((v) => _addType(v, sort))
        // .map((v) => Submission.fromJson(v, type: SubType.hot))
        .map((v) => Subreddit.fromJson(v));

    for (final item in items) {
      await Future.delayed(_delay);
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

  // Future<bool> isLoggedIn() async => _isLoggedIn;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> login() async {
    _log.info('login()');
    // if (user != 'fake' || pass != 'fake') {
    //   throw Exception('fail to login, use user=fake, pass=fake for login');
    // }
    await File(await _loginPath()).create();
    _isLoggedIn = true;
    return;
  }

  Future<bool> loginSilently() async {
    _isLoggedIn = await File(await _loginPath()).exists();
    _log.info('loginSilently: $_isLoggedIn');
    return _isLoggedIn;
    // _isLoggedIn = true;
    // return true;
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
    _mustLoggedIn();
    final data = await File('data/inbox.messages.json').readAsString();

    final items = (jsonDecode(data) as List<dynamic>)
        // .map((v) => v as Map<dynamic, dynamic>)
        // .map((v) => _addType(v, sort))
        // .map((v) => Submission.fromJson(v, type: SubType.hot))
        .map((v) => Message.fromJson(v));

    for (final item in items) {
      await Future.delayed(_delay);
      yield item;
    }
  }
}
