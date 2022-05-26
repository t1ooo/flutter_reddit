import 'package:draw/draw.dart' as draw;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_reddit_prototype/src/reddit_api/rule.dart';

import '../logging.dart';
import 'auth.dart';
import 'comment.dart';
import 'credentials.dart';
import 'like.dart';
import 'message.dart';
import 'parse.dart';
import 'reddit_api.dart';
import 'submission.dart';
import 'submission_type.dart';
import 'subreddit.dart';
import 'trophy.dart';
import 'user.dart';

class RedditApiImpl implements RedditApi {
  RedditApiImpl(this.clientId, this.auth, this.credentials) {
    if (clientId == '') {
      throw Exception('clientId is empty');
    }
  }

  // TODO: make fields private
  final userAgent = 'Flutter Client';
  final String clientId;

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

    final credentialsJson = await credentials.read() ?? '';
    if (credentialsJson == '') {
      return false;
    }

    // TODO: replace to restoreInstalledAuthenticatedInstance
    _reddit = draw.Reddit.restoreAuthenticatedInstance(
      credentialsJson,
      clientId: clientId,
      userAgent: userAgent,
    );

    return true;
  }

  Future<void> login() async {
    if (_reddit != null) {
      return;
    }

    _reddit = draw.Reddit.createInstalledFlowInstance(
      clientId: clientId,
      userAgent: userAgent,
      redirectUri: auth.redirectUri,
    );

    final authUrl = reddit.auth.url(['*'], 'state');
    launch(authUrl.toString());

    final authCode = await auth.stream.first;
    await reddit.auth.authorize(authCode);

    await credentials.write(reddit.auth.credentials.toJson());
  }

  Future<List<Submission>> front({
    required int limit,
    required FrontSubType type,
  }) async {
    return _parseSubmissions(await _front(limit: limit, type: type).toList());
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

  Future<List<Submission>> popular({
    required int limit,
    required SubType type,
  }) async {
    return _parseSubmissions(
        await _subredditSubmissions('popular', limit: limit, type: type)
            .toList());
  }

  Future<List<Submission>> all({
    required int limit,
    required SubType type,
  }) async {
    return _parseSubmissions(
        await _subredditSubmissions('all', limit: limit, type: type).toList());
  }

  Future<List<Submission>> subredditSubmissions(
    Subreddit subreddit, {
    required int limit,
    required SubType type,
  }) async {
    return _parseSubmissions(await _subredditSubmissions(subreddit.displayName,
            limit: limit, type: type)
        .toList());
  }

  Stream<draw.UserContent> _subredditSubmissions(
    String name, {
    required int limit,
    required SubType type,
  }) {
    name = removeSubredditPrefix(name);
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

  Future<List<Subreddit>> currentUserSubreddits({required int limit}) async {
    return _parseSubreddits(
        await reddit.user.subreddits(limit: limit).toList());
  }

  Future<User> user(String name) async {
    return _parseUser(await reddit.redditor(name).populate());
  }

  Future<void> userBlock(User user, bool block) async {
    if (block) {
      final params = {'name': user.name};
      await reddit.post('/api/block_user/', params);
    } else {
      return user.drawRedditor!.unblock();
    }
  }

  // TODO: MAYBE: add type support
  Future<List<Comment>> userComments(
    User user, {
    required int limit,
  }) async {
    return _parseComments(
        await user.drawRedditor!.comments.newest(limit: limit).toList());
  }

// TODO: MAYBE: add type support
  Future<List<Submission>> userSubmissions(User user,
      {required int limit}) async {
    return _parseSubmissions(
        await user.drawRedditor!.submissions.newest(limit: limit).toList());
  }

  Future<List<Trophy>> userTrophies(User user) async {
    // return (await user.drawRedditor!.trophies())
    //     .map(_parseTrophy)
    //     .whereType<Trophy>()
    //     .toList();
    return _parseTrophies(await await user.drawRedditor!.trophies());
  }

  Future<void> subredditSubscribe(Subreddit subreddit, bool subscribe) {
    return subscribe
        ? subreddit.drawSubreddit!.subscribe()
        : subreddit.drawSubreddit!.unsubscribe();
  }

  // TODO: merge with subredditUnfavorite
  Future<void> subredditFavorite(Subreddit subreddit, bool favorite) {
    return reddit.post(
      '/api/favorite/',
      {
        'make_favorite': favorite.toString(),
        'sr_name': subreddit.displayName,
        'api_type': 'json',
      },
      objectify: false,
    );
  }

  Future<Submission> submission(String id) async {
    return _parseSubmission(await reddit.submission(id: id).populate());
  }

  Future<Subreddit> subreddit(String name) async {
    name = removeSubredditPrefix(name);
    return _parseSubreddit(await reddit.subreddit(name).populate());
  }

  Future<void> submissionLike(Submission submission, Like like) async {
    return _like(submission.drawSubmission!, like);
  }

  Future<void> commentLike(Comment comment, Like like) async {
    return _like(comment.drawComment!, like);
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

  Future<void> submissionSave(Submission submission, bool save) async {
    return save
        ? submission.drawSubmission!.save()
        : submission.drawSubmission!.unsave();
  }

  Future<void> submissionHide(Submission submission, bool hide) async {
    return hide
        ? submission.drawSubmission!.hide()
        : submission.drawSubmission!.unhide();
  }

  Future<void> commentSave(Comment comment, bool save) async {
    return save ? comment.drawComment!.save() : comment.drawComment!.unsave();
  }

  Future<User?> currentUser() async {
    final redditor = await reddit.user.me();
    if (redditor == null) {
      return null;
    }
    return _parseUser(redditor);
  }

  Future<UserSaved> userSaved(User user, {required int limit}) async {
    final submissions = <Submission?>[];
    final comments = <Comment?>[];
    await for (final v in user.drawRedditor!.saved(limit: limit)) {
      if (v is draw.Submission)
        submissions.add(_parseSubmission(v));
      else if (v is draw.Comment)
        comments.add(_parseComment(v));
      else
        _log.warning('undefined type');
    }

    return UserSaved(
      submissions.whereType<Submission>().toList(),
      comments.whereType<Comment>().toList(),
    );
  }

  Future<List<Submission>> search(
    String query, {
    required int limit,
    required Sort sort,
    String subreddit = 'all',
  }) async {
    subreddit = removeSubredditPrefix(subreddit);
    final params = {'limit': limit.toString()};
    return _parseSubmissions(await reddit
        .subreddit(subreddit)
        .search(query, params: params)
        .toList());
  }

  Future<List<Subreddit>> searchSubreddits(String query,
      {required int limit}) async {
    return _parseSubreddits(await reddit.subreddits
        .search(query, limit: limit)
        .map((v) => v as draw.Subreddit)
        .toList());
  }

  Future<Comment> submissionReply(Submission submission, String body) async {
    return _parseComment(await submission.drawSubmission!.reply(body));
  }

  Future<void> submissionReport(Submission submission, String reason) async {
    return submission.drawSubmission!.report(reason);
  }

  Future<void> commentReport(Comment comment, String reason) async {
    return comment.drawComment!.report(reason);
  }

  Future<Comment> commentReply(Comment comment, String body) async {
    return _parseComment(await comment.drawComment!.reply(body));
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
    return _parseSubmission(
      await reddit.subreddit(subreddit).submit(
            title,
            selftext: selftext,
            url: url,
            resubmit: resubmit,
            sendReplies: sendReplies,
            nsfw: nsfw,
            spoiler: spoiler,
          ),
    );
  }

  Future<List<Message>> inboxMessages() async {
    return _parseMessages(await reddit.inbox.messages().toList());
  }

  Future<List<Rule>> subredditRules(Subreddit subreddit) async {
    final resp = await reddit.get('/r/${subreddit.displayName}/about/rules',
        objectify: false);
    return parseRules(resp)!;
  }

  // TODO: move outside class
  Submission _parseSubmission(draw.Submission v) {
    final comments = v.comments?.comments
        .map((v) => _parseComment(v))
        .whereType<Comment>()
        .toList();
    return Submission.fromJson(v.data!, comments: comments);
  }

  Subreddit _parseSubreddit(draw.Subreddit v) {
    return Subreddit.fromJson(v.data! as Map<String, dynamic>,
        drawSubreddit: v);
  }

  Message _parseMessage(draw.Message v) {
    return Message.fromJson(v.data! as Map<String, dynamic>);
  }

  Comment _parseComment(draw.Comment v) {
    return Comment.fromJson(v.data! as Map<String, dynamic>, drawComment: v);
  }

  User _parseUser(draw.Redditor v) {
    return User.fromJson(v.data! as Map<String, dynamic>, drawRedditor: v);
  }

  Trophy _parseTrophy(draw.Trophy v) {
    return Trophy.fromJson(v.data! as Map<String, dynamic>);
  }

  List<R> _parse<T, R>(Iterable<T> s, R Function(T) parser) {
    return s
        .map((v) {
          try {
            return parser(v);
          } on TypeError catch (e, st) {
            _log.warning('', e, st);
          } on Exception catch (e, st) {
            _log.warning('', e, st);
          }
          return null;
        })
        .whereType<R>()
        .toList();
  }

  List<Submission> _parseSubmissions(
    Iterable<draw.UserContent> s,
  ) {
    return _parse<draw.Submission, Submission>(
        s.whereType<draw.Submission>(), _parseSubmission);
  }

  List<Comment> _parseComments(Iterable<draw.UserContent> s) {
    return _parse<draw.Comment, Comment>(
        s.whereType<draw.Comment>(), _parseComment);
  }

  List<Subreddit> _parseSubreddits(Iterable<draw.Subreddit> s) {
    return _parse<draw.Subreddit, Subreddit>(s, _parseSubreddit);
  }

  List<Message> _parseMessages(Iterable<draw.Message> s) {
    return _parse<draw.Message, Message>(s, _parseMessage);
  }

  List<Trophy> _parseTrophies(Iterable<draw.Trophy> s) {
    return _parse<draw.Trophy, Trophy>(s, _parseTrophy);
  }
}
