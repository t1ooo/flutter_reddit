import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import '../logging.dart';
import 'comment.dart';
import 'like.dart';
import 'message.dart';
import 'parse.dart';
import 'reddit_api.dart';
import 'rule.dart';
import 'submission.dart';
import 'submission_type.dart';
import 'subreddit.dart';
import 'trophy.dart';
import 'user.dart';

class FakeRedditApi implements RedditApi {
  FakeRedditApi();

  static final _log = getLogger('FakeRedditApi');

  static final _delay = Duration(seconds: 1 ~/ 2);

  Map<String, dynamic> _addType(Map<String, dynamic> v, Enum type) {
    v['title'] = '$type: ${v['title']}';
    return v;
  }

  Future<String> _readFile(String path) {
    return rootBundle.loadString('assets/fake_reddit_api/$path');
  }

  T _randValue<T>(List<T> list) {
    return list[Random().nextInt(list.length)];
  }

  @override
  Future<List<Submission>> front({
    required int limit,
    required FrontSubType type,
  }) async {
    _log.info('front($limit, $type)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('user.front.json');
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => _addType(v, type))
        .map((v) => Submission.fromJson(v))
        .take(limit)
        .toList();
  }

  static final _random = Random(42);

  @override
  Future<List<Submission>> popular({
    required int limit,
    required SubType type,
  }) async {
    _log.info('popular($limit, $type)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('popular.json');

    return (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => _addType(v, type))
        .map((v) => Submission.fromJson(v))
        .take(limit)
        .toList();
  }

  @override
  Future<List<Submission>> all({
    required int limit,
    required SubType type,
  }) async {
    _log.info('all($limit, $type)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('popular.json');

    return (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
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
    final data = await _readFile('user.subreddits.json');
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => Subreddit.fromJson(v))
        .take(limit)
        .toList();
  }

  @override
  Future<List<Submission>> subredditSubmissions(
    Subreddit subreddit, {
    required int limit,
    required SubType type,
  }) async {
    _log.info('subredditSubmissions(${subreddit.name}, $limit, $type)');
    await Future.delayed(_delay);
    _mustLoggedIn();

    final data = await _readFile('subreddit.submissions.json');
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => _addType(v, type))
        .map((v) => Submission.fromJson(v))
        .take(limit)
        .toList();
  }

  @override
  Future<User> user(String name) async {
    _log.info('user($name)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('user.info.json');
    return User.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  @override
  Future<List<Comment>> userComments(User user, {required int limit}) async {
    _log.info('userComments(${user.name}, $limit)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('user.comments.json');
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => Comment.fromJson(v))
        .take(limit)
        .toList();
  }

  @override
  Future<List<Submission>> userSubmissions(
    User user, {
    required int limit,
  }) async {
    _log.info('userSubmissions(${user.name}, $limit)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('user.submissions.json');
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => Submission.fromJson(v))
        .take(limit)
        .toList();
  }

  @override
  Future<List<Trophy>> userTrophies(User user) async {
    _log.info('userTrophies(${user.name})');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('user.trophies.json');
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => Trophy.fromJson(v))
        .toList();
  }

  @override
  Future<void> subredditSubscribe(Subreddit subreddit, bool subscribe) async {
    _log.info('subscribe(${subreddit.name}, $subscribe)');
    await Future.delayed(_delay);
    _mustLoggedIn();

    return;
  }

  @override
  Future<void> subredditFavorite(Subreddit subreddit, bool favorite) async {
    _log.info('subredditFavorite(${subreddit.name}, $favorite)');
    await Future.delayed(_delay);
    return;
  }

  @override
  Future<Submission> submission(String id) async {
    _log.info('submission($id)');
    await Future.delayed(_delay);
    _mustLoggedIn();

    final subData = await _readFile('submission.json');
    final comData = await _readFile('submission.comments.json');

    final comments = (jsonDecode(comData) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => Comment.fromJson(v))
        .toList();

    return Submission.fromJson(
      jsonDecode(subData) as Map<String, dynamic>,
      comments: comments,
    );
  }

  @override
  Future<Subreddit> subreddit(String name) async {
    _log.info('subreddit($name)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    // ignore: parameter_assignments
    name = removeSubredditPrefix(name);
    final files = ['subreddit.1.json', 'subreddit.2.json'];
    final data = await _readFile(_randValue(files));
    final map = jsonDecode(data) as Map;
    map['user_is_subscriber'] = _random.nextInt(1000).isEven;
    return Subreddit.fromJson(map as Map<String, dynamic>);
  }

  @override
  Future<void> submissionLike(Submission submission, Like like) async {
    _log.info('submissionLike(${submission.id}, $like)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    return;
  }

  @override
  Future<void> commentLike(Comment comment, Like like) async {
    _log.info('commentLike(${comment.id}, $like)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    return;
  }

  @override
  Future<void> submissionSave(Submission submission, bool save) async {
    _log.info('submissionSave(${submission.id}), $save');
    await Future.delayed(_delay);
    _mustLoggedIn();
    return;
  }

  @override
  Future<void> submissionHide(Submission submission, bool hide) async {
    _log.info('submissionHide(${submission.id}), $hide');
    await Future.delayed(_delay);
    _mustLoggedIn();
    return;
  }

  @override
  Future<void> commentSave(Comment comment, bool save) async {
    _log.info('commentSave(${comment.id}, $save)');
    await Future.delayed(_delay);
    _mustLoggedIn();

    return;
  }

  @override
  Future<User?> currentUser() async {
    _log.info('currentUser()');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('user.current.info.json');
    final json = jsonDecode(data);
    // ignore: avoid_dynamic_calls
    json['name'] += '_${Random().nextInt(1000)}';
    return User.fromJson(json as Map<String, dynamic>);
  }

  @override
  Future<UserSaved> userSaved(User user, {required int limit}) async {
    _log.info('userSaved(${user.name}, $limit)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('user.current.saved.json');
    final submissions = <Submission>[];
    final comments = <Comment>[];

    final items = (jsonDecode(data) as List<dynamic>)
        .take(limit)
        .map((v) => v as Map<String, dynamic>)
        .forEach((v) {
      if ((v['name'] as String).contains('t1_')) {
        comments.add(Comment.fromJson(v));
      } else {
        submissions.add(Submission.fromJson(v));
      }
    });

    return UserSaved(
      submissions + submissions + submissions,
      comments + comments + comments,
    );
  }

  @override
  Future<List<Submission>> search(
    String query, {
    required int limit,
    required Sort sort,
    String subreddit = 'all',
  }) async {
    _log.info('search($query, $limit, $sort, $subreddit)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    // ignore: parameter_assignments
    subreddit = removeSubredditPrefix(subreddit);
    final data = await _readFile('search.json');

    return (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => _addType(v, sort))
        .map((v) => Submission.fromJson(v))
        .take(limit)
        .toList();
  }

  @override
  Future<List<Subreddit>> searchSubreddits(
    String query, {
    required int limit,
  }) async {
    _log.info('searchSubreddits($query, $limit)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('subreddits.search.json');
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => Subreddit.fromJson(v))
        .take(limit)
        .toList();
  }

  @override
  Future<Comment> submissionReply(Submission submission, String body) async {
    _log.info('submissionReply(${submission.id}, $body)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return Comment.fromJson({'body': body});
  }

  @override
  Future<Comment> commentReply(Comment comment, String body) async {
    _log.info('commentReply(${comment.id}, $body)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return Comment.fromJson({'body': body});
  }

  Future<String> _loginPath() async {
    return '${(await getTemporaryDirectory()).path}/fake_reddit_api.login';
  }

  void _mustLoggedIn() {
    if (!_isLoggedIn) {
      throw Exception('login to continue');
    }
  }

  bool _isLoggedIn = false;

  @override
  bool get isLoggedIn => _isLoggedIn;

  @override
  Future<void> login() async {
    _log.info('login()');

    await File(await _loginPath()).create();
    _isLoggedIn = true;
    return;
  }

  @override
  Future<bool> loginSilently() async {
    await Future.delayed(_delay);
    // ignore: avoid_slow_async_io
    _isLoggedIn = await File(await _loginPath()).exists();
    _log.info('loginSilently: $_isLoggedIn');
    return _isLoggedIn;
  }

  @override
  Future<void> logout() async {
    _log.info('logout()');
    await File(await _loginPath()).delete();
    _isLoggedIn = false;
    return;
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

  @override
  Future<List<Message>> inboxMessages() async {
    _log.info('inboxMessages()');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('inbox.messages.json');

    return (jsonDecode(data) as List<dynamic>)
        .map((v) => v as Map<String, dynamic>)
        .map((v) => Message.fromJson(v))
        .toList();
  }

  @override
  Future<void> userBlock(User user, bool block) async {
    _log.info('userBlock(${user.name}, $block)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return;
  }

  @override
  Future<void> submissionReport(Submission submission, String reason) async {
    _log.info('submissionReport(${submission.id}, $reason)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return;
  }

  @override
  Future<void> commentReport(Comment comment, String reason) async {
    _log.info('commentReport(${comment.id}, $reason)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return;
  }

  @override
  Future<List<Rule>> subredditRules(Subreddit subreddit) async {
    _log.info('subredditRules(${subreddit.name})');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('subreddit.2.rules.json');
    return parseRules(jsonDecode(data))!;
  }
}
