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

  /// Draw object cache. Only use cached values for actions that unnecessarily fetch objects from the server (e.g. commentLike, commentDislike).

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
    return _parseSubmissionStream(_front(limit: limit, type: type));
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
    return _parseSubmissionStream(
        _subredditSubmissions('popular', limit: limit, type: type));
  }

  Future<List<Submission>> all({
    required int limit,
    required SubType type,
  }) async {
    return _parseSubmissionStream(
        _subredditSubmissions('all', limit: limit, type: type));
  }

  Future<List<Subreddit>> currentUserSubreddits({required int limit}) {
    return _parseSubredditStream(reddit.user.subreddits(limit: limit));
  }

  Future<List<Submission>> subredditSubmissions(
    Subreddit subreddit, {
    required int limit,
    required SubType type,
  }) async {
    return (await _subredditSubmissions(subreddit.displayName,
                limit: limit, type: type)
            .toList())
        .whereType<draw.Submission>()
        .map(_parseSubmission)
        .whereType<Submission>()
        .toList();
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

  Future<User> user(String name) async {
    return _parseUser(await reddit.redditor(name).populate())!;
  }

  Future<void> userBlock(User user) async {
    final params = {'name': user.name};
    await reddit.post('/api/block_user/', params);
  }

  Future<void> userUnblock(User user) async {
    return user.drawRedditor!.unblock();
  }

  // TODO: MAYBE: add type support
  Future<List<Comment>> userComments(
    User user, {
    required int limit,
  }) {
    return _parseCommentStream(
        user.drawRedditor!.comments.newest(limit: limit));
  }

// TODO: MAYBE: add type support
  Future<List<Submission>> userSubmissions(User user, {required int limit}) {
    return _parseSubmissionStream(
        user.drawRedditor!.submissions.newest(limit: limit));
  }

  Future<List<Trophy>> userTrophies(User user) async {
    return (await user.drawRedditor!.trophies())
        .map(_parseTrophy)
        .whereType<Trophy>()
        .toList();
  }

  // TODO: rename to subredditSubscribe
  Future<void> subredditSubscribe(Subreddit subreddit) {
    return subreddit.drawSubreddit!.subscribe();
  }

  Future<void> subredditUnsubscribe(Subreddit subreddit) {
    return subreddit.drawSubreddit!.unsubscribe();
  }

  // TODO: merge with subredditUnfavorite
  Future<void> subredditFavorite(Subreddit subreddit) {
    return reddit.post(
      '/api/favorite/',
      {
        'make_favorite': 'true',
        'sr_name': subreddit.displayName,
        'api_type': 'json',
      },
      objectify: false,
    );
  }

  Future<void> subredditUnfavorite(Subreddit subreddit) {
    return reddit.post(
      '/api/favorite/',
      {
        'make_favorite': 'false',
        'sr_name': subreddit.displayName,
        'api_type': 'json',
      },
      objectify: false,
    );
  }

  // TODO: parse submission
  Future<Submission> submission(String id) async {
    return _parseSubmission(await reddit.submission(id: id).populate());
  }

  // TODO: parse subreddit
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

  Future<void> submissionSave(Submission submission) async {
    return submission.drawSubmission!.save();
  }

  Future<void> submissionUnsave(Submission submission) async {
    return submission.drawSubmission!.unsave();
  }

  Future<void> submissionHide(Submission submission) async {
    return submission.drawSubmission!.hide();
  }

  Future<void> submissionUnhide(Submission submission) async {
    return submission.drawSubmission!.unhide();
  }

  Future<void> commentSave(Comment comment) async {
    return comment.drawComment!.save();
  }

  Future<void> commentUnsave(Comment comment) async {
    return comment.drawComment!.unsave();
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
  }) {
    subreddit = removeSubredditPrefix(subreddit);
    final params = {'limit': limit.toString()};

    return _parseSubmissionStream(
        reddit.subreddit(subreddit).search(query, params: params));
  }

  Future<List<Subreddit>> searchSubreddits(String query, {required int limit}) {
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
  }

  Future<Comment> submissionReply(Submission submission, String body) async {
    final comment = await submission.drawSubmission!.reply(body);
    return _parseComment(comment);
  }

  Future<void> submissionReport(Submission submission, String reason) async {
    return submission.drawSubmission!.report(reason);
  }

  Future<void> commentReport(Comment comment, String reason) async {
    return comment.drawComment!.report(reason);
  }

  Future<Comment> commentReply(Comment comment, String body) async {
    final commentReply = await comment.drawComment!.reply(body);
    return _parseComment(commentReply);
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
    return _parseSubmission(sub);
  }

  Future<List<Message>> inboxMessages() async {
    return _parseMessageStream(reddit.inbox.messages());
  }

  Future<List<Rule>> subredditRules(Subreddit subreddit) async {
    final resp = await reddit.get('/r/${subreddit.displayName}/about/rules',
        objectify: false);
    return parseRules(resp)!;
  }

  // TODO: move outside class
  Submission _parseSubmission(draw.UserContent v) {
    v = v as draw.Submission;
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

  Comment _parseComment(draw.UserContent v) {
    v = v as draw.Comment;
    return Comment.fromJson(v.data! as Map<String, dynamic>, drawComment: v);
  }

  User? _parseUser(draw.Redditor v) {
    return User.fromJson(v.data! as Map<String, dynamic>, drawRedditor: v);
  }

  Trophy? _parseTrophy(draw.Trophy v) {
    return Trophy.fromJson(v.data! as Map<String, dynamic>);
  }

  Future<List<R>> _parseStream<T, R>(Stream<T> s, R Function(T) parser) async {
    return (await s.toList())
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

  Future<List<Submission>> _parseSubmissionStream(
    Stream<draw.UserContent> s,
  ) {
    return _parseStream<draw.UserContent, Submission>(s, _parseSubmission);
  }

  Future<List<Comment>> _parseCommentStream(Stream<draw.UserContent> s) {
    return _parseStream<draw.UserContent, Comment>(s, _parseComment);
  }

  Future<List<Subreddit>> _parseSubredditStream(Stream<draw.Subreddit> s) {
    return _parseStream<draw.Subreddit, Subreddit>(s, _parseSubreddit);
  }

  Future<List<Message>> _parseMessageStream(Stream<draw.Message> s) {
    return _parseStream<draw.Message, Message>(s, _parseMessage);
  }
}
