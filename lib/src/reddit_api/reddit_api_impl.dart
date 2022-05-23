import 'package:draw/draw.dart' as draw;
import 'package:flutter_reddit_prototype/src/reddit_api/rule.dart';
import 'package:url_launcher/url_launcher.dart';

import '../logging.dart';
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

class RedditApiImpl implements RedditApi {
  // RedditApiImpl(this.clientId, this.redirectUri, this.credentials);
  RedditApiImpl(this.clientId, this.auth, this.credentials);

  final userAgent = 'Flutter Client';
  final String clientId;
  // final Uri redirectUri;
  final Auth auth;
  final Credentials credentials;
  static final _log = getLogger('RedditApiImpl');
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

    final credentialsJson = await credentials.read();

    if (credentialsJson == '') {
      return false;
    }

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

  Future<List<Rule>> subredditRules(String name) async {
    name = removeSubredditPrefix(name);
    final resp = await reddit.get('/r/$name/about/rules', objectify: false);
    return parseRules(resp)!;
  }
}
