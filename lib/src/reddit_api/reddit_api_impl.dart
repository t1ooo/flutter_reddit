import 'package:draw/draw.dart' as draw;
import 'package:url_launcher/url_launcher.dart';

import '../logging.dart';
import 'auth.dart';
import 'comment.dart';
import 'credentials.dart';
import 'like.dart';
import 'message.dart';

import 'parsers.dart';
import 'reddit_api.dart';
import 'rule.dart';
import 'submission.dart';
import 'submission_type.dart';
import 'subreddit.dart';
import 'trophy.dart';
import 'user.dart';

class RedditApiImpl implements RedditApi {
  RedditApiImpl(this._clientId, this._auth, this._credentials) {
    if (_clientId == '') {
      throw Exception('clientId is empty');
    }
  }

  static const _userAgent = 'Flutter Client';
  static final _log = getLogger('RedditApiImpl');
  final String _clientId;
  final Auth _auth;
  final Credentials _credentials;

  draw.Reddit? _reddit;
  draw.Reddit get reddit {
    if (_reddit == null) {
      throw Exception('not logged in');
    }
    return _reddit!;
  }

  @override
  bool get isLoggedIn => _reddit != null;

  @override
  Future<void> logout() async {
    _reddit = null;
    await _credentials.delete();
  }

  @override
  Future<bool> loginSilently() async {
    if (_reddit != null) {
      return true;
    }

    final credentialsJson = await _credentials.read() ?? '';
    if (credentialsJson == '') {
      return false;
    }

    _reddit = draw.Reddit.restoreInstalledAuthenticatedInstance(
      credentialsJson,
      clientId: _clientId,
      userAgent: _userAgent,
    );

    return true;
  }

  @override
  Future<void> login() async {
    if (_reddit != null) {
      return;
    }

    _reddit = draw.Reddit.createInstalledFlowInstance(
      clientId: _clientId,
      userAgent: _userAgent,
      redirectUri: _auth.redirectUri,
    );

    final authUrl = reddit.auth.url(['*'], 'state');
    // ignore: unawaited_futures
    launch(authUrl.toString());

    final authCode = await _auth.stream.first;
    await reddit.auth.authorize(authCode);

    await _credentials.write(reddit.auth.credentials.toJson());
  }

  @override
  Future<List<Submission>> front({
    required int limit,
    required FrontSubType type,
  }) async {
    return submissionParser
        .parseDraws(await _front(limit: limit, type: type).toList());
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

  @override
  Future<List<Submission>> popular({
    required int limit,
    required SubType type,
  }) async {
    return submissionParser.parseDraws(
      await _subredditSubmissions('popular', limit: limit, type: type).toList(),
    );
  }

  @override
  Future<List<Submission>> all({
    required int limit,
    required SubType type,
  }) async {
    return submissionParser.parseDraws(
      await _subredditSubmissions('all', limit: limit, type: type).toList(),
    );
  }

  @override
  Future<List<Submission>> subredditSubmissions(
    Subreddit subreddit, {
    required int limit,
    required SubType type,
  }) async {
    return submissionParser.parseDraws(
      await _subredditSubmissions(
        subreddit.displayName,
        limit: limit,
        type: type,
      ).toList(),
    );
  }

  Stream<draw.UserContent> _subredditSubmissions(
    String name, {
    required int limit,
    required SubType type,
  }) {
    // ignore: parameter_assignments
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

  @override
  Future<List<Subreddit>> currentUserSubreddits({required int limit}) async {
    return subredditParser
        .parseDraws(await reddit.user.subreddits(limit: limit).toList());
  }

  @override
  Future<User> user(String name) async {
    return userParser.parseDraw(await reddit.redditor(name).populate());
  }

  @override
  Future<void> userBlock(User user, bool block) async {
    if (block) {
      final params = {'name': user.name};
      await reddit.post('/api/block_user/', params);
    } else {
      return user.drawRedditor!.unblock();
    }
  }

  @override
  Future<List<Comment>> userComments(
    User user, {
    required int limit,
  }) async {
    return commentParser.parseDraws(
      await user.drawRedditor!.comments.newest(limit: limit).toList(),
    );
  }

  @override
  Future<List<Submission>> userSubmissions(
    User user, {
    required int limit,
  }) async {
    return submissionParser.parseDraws(
      await user.drawRedditor!.submissions.newest(limit: limit).toList(),
    );
  }

  @override
  Future<List<Trophy>> userTrophies(User user) async {
    return trophyParser.parseDraws(await user.drawRedditor!.trophies());
  }

  @override
  Future<void> subredditSubscribe(Subreddit subreddit, bool subscribe) {
    return subscribe
        ? subreddit.drawSubreddit!.subscribe()
        : subreddit.drawSubreddit!.unsubscribe();
  }

  @override
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

  @override
  Future<Submission> submission(String id) async {
    return submissionParser
        .parseDraw(await reddit.submission(id: id).populate());
  }

  @override
  Future<Subreddit> subreddit(String name) async {
    // ignore: parameter_assignments
    name = removeSubredditPrefix(name);
    return subredditParser.parseDraw(await reddit.subreddit(name).populate());
  }

  @override
  Future<void> submissionLike(Submission submission, Like like) async {
    return _like(submission.drawSubmission!, like);
  }

  @override
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

  @override
  Future<void> submissionSave(Submission submission, bool save) async {
    return save
        ? submission.drawSubmission!.save()
        : submission.drawSubmission!.unsave();
  }

  @override
  Future<void> submissionHide(Submission submission, bool hide) async {
    return hide
        ? submission.drawSubmission!.hide()
        : submission.drawSubmission!.unhide();
  }

  @override
  Future<void> commentSave(Comment comment, bool save) async {
    return save ? comment.drawComment!.save() : comment.drawComment!.unsave();
  }

  @override
  Future<User?> currentUser() async {
    final redditor = await reddit.user.me();
    if (redditor == null) {
      return null;
    }
    return userParser.parseDraw(redditor);
  }

  @override
  Future<UserSaved> userSaved(User user, {required int limit}) async {
    final submissions = <Submission?>[];
    final comments = <Comment?>[];
    await for (final v in user.drawRedditor!.saved(limit: limit)) {
      if (v is draw.Submission) {
        submissions.add(submissionParser.parseDraw(v));
      } else if (v is draw.Comment) {
        comments.add(commentParser.parseDraw(v));
      } else {
        _log.warning('undefined type');
      }
    }

    return UserSaved(
      submissions.whereType<Submission>().toList(),
      comments.whereType<Comment>().toList(),
    );
  }

  @override
  Future<List<Submission>> search(
    String query, {
    required int limit,
    required Sort sort,
    String subreddit = 'all',
  }) async {
    // ignore: parameter_assignments
    subreddit = removeSubredditPrefix(subreddit);
    final params = {'limit': limit.toString()};
    return submissionParser.parseDraws(
      await reddit.subreddit(subreddit).search(query, params: params).toList(),
    );
  }

  @override
  Future<List<Subreddit>> searchSubreddits(
    String query, {
    required int limit,
  }) async {
    return subredditParser.parseDraws(
      await reddit.subreddits
          .search(query, limit: limit)
          .map((v) => v as draw.Subreddit)
          .toList(),
    );
  }

  @override
  Future<Comment> submissionReply(Submission submission, String body) async {
    return commentParser
        .parseDraw(await submission.drawSubmission!.reply(body));
  }

  @override
  Future<void> submissionReport(Submission submission, String reason) async {
    return submission.drawSubmission!.report(reason);
  }

  @override
  Future<void> commentReport(Comment comment, String reason) async {
    return comment.drawComment!.report(reason);
  }

  @override
  Future<Comment> commentReply(Comment comment, String body) async {
    return commentParser.parseDraw(await comment.drawComment!.reply(body));
  }

  @override
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
    return submissionParser.parseDraw(
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

  @override
  Future<List<Message>> inboxMessages() async {
    return messageParser.parseDraws(await reddit.inbox.messages().toList());
  }

  @override
  Future<List<Rule>> subredditRules(Subreddit subreddit) async {
    final resp = await reddit.get(
      '/r/${subreddit.displayName}/about/rules',
      objectify: false,
    );
    return ruleParser.parse(resp);
  }
}
