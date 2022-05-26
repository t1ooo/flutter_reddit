import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_reddit_prototype/src/reddit_api/rule.dart';
import 'package:path_provider/path_provider.dart';

import '../logging.dart';
import 'message.dart';
import 'parse.dart';
import 'trophy.dart';
import 'user.dart';
import 'comment.dart';
import 'submission.dart';
import 'submission_type.dart';
import 'subreddit.dart';
import 'like.dart';
import 'reddit_api.dart';

class FakeRedditApi implements RedditApi {
  FakeRedditApi();

  static final _log = getLogger('FakeRedditApi');

  Duration _delay = Duration(seconds: 1 ~/ 2);

  Map _addType(Map v, Enum type) {
    v['title'] = '$type: ${v['title']}';
    return v;
  }

  Future<String> _readFile(String path) {
    return rootBundle.loadString('assets/fake_reddit_api/$path');
  }

  // Future<String> _readRandFile(List<String> paths) {
  //   return _readFile(paths[Random().nextInt(paths.length)]);
  // }
  T _randValue<T>(List<T> list) {
    return list[Random().nextInt(list.length)];
  }

  Future<List<Submission>> front({
    required int limit,
    required FrontSubType type,
  }) async {
    _log.info('front($limit, $type)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('user.front.json');
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
    final data = await _readFile('popular.json');

    return (jsonDecode(data) as List<dynamic>)
        .map((v) => _addType(v, type))
        .map((v) => Submission.fromJson(v))
        .take(limit)
        .toList();
  }

  Future<List<Submission>> all({
    required int limit,
    required SubType type,
  }) async {
    _log.info('all($limit, $type)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('popular.json');

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
    final data = await _readFile('user.subreddits.json');
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => Subreddit.fromJson(v))
        .take(limit)
        .toList();
  }

  Future<List<Submission>> subredditSubmissions(
    Subreddit subreddit, {
    required int limit,
    required SubType type,
  }) async {
    _log.info('subredditSubmissions(${subreddit.name}, $limit, $type)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    // name = removeSubredditPrefix(name);
    final data = await _readFile('subreddit.submissions.json');
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
    final data = await _readFile('user.info.json');
    return User.fromJson(jsonDecode(data));
  }

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

  Future<List<Submission>> userSubmissions(
    User user, {
    required int limit,
  }) async {
    _log.info('userSubmissions(${user.name}, $limit)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('user.submissions.json');
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => Submission.fromJson(v))
        .take(limit)
        .toList();
  }

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

  Future<void> subredditSubscribe(Subreddit subreddit) async {
    _log.info('subscribe(${subreddit.name})');
    await Future.delayed(_delay);
    _mustLoggedIn();
    // name = removeSubredditPrefix(name);
    return;
  }

  Future<void> subredditUnsubscribe(Subreddit subreddit) async {
    _log.info('unsubscribe(${subreddit.name})');
    await Future.delayed(_delay);
    _mustLoggedIn();
    // name = removeSubredditPrefix(name);
    return;
  }

  Future<void> subredditFavorite(Subreddit subreddit) async {
    await Future.delayed(_delay);
    _log.info('subredditFavorite(${subreddit.name})');
    return;
  }

  Future<void> subredditUnfavorite(Subreddit subreddit) async {
    _log.info('subredditUnfavorite(${subreddit.name})');
    await Future.delayed(_delay);
    return;
  }

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
      jsonDecode(subData) as Map,
      comments: comments,
    );
  }

  Future<Subreddit> subreddit(String name) async {
    _log.info('subreddit($name)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    name = removeSubredditPrefix(name);
    final files = ['subreddit.1.json', 'subreddit.2.json'];
    final data = await _readFile(_randValue(files));
    final map = jsonDecode(data) as Map;
    map['user_is_subscriber'] = _random.nextInt(1000) % 2 == 0;
    return Subreddit.fromJson(map as Map<String, dynamic>);
  }

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

  Future<void> submissionSave(Submission submission) async {
    _log.info('submissionSave(${submission.id})');
    await Future.delayed(_delay);
    _mustLoggedIn();
    return;
  }

  Future<void> submissionUnsave(Submission submission) async {
    _log.info('submissionUnsave(${submission.id})');
    await Future.delayed(_delay);
    _mustLoggedIn();
    return;
  }

  Future<void> submissionHide(Submission submission) async {
    _log.info('submissionHide(${submission.id})');
    await Future.delayed(_delay);
    _mustLoggedIn();
    return;
  }

  Future<void> submissionUnhide(Submission submission) async {
    _log.info('submissionUnhide(${submission.id})');
    await Future.delayed(_delay);
    _mustLoggedIn();
    return;
  }

  Future<void> commentSave(Comment comment) async {
    _log.info('commentSave(${comment.id})');
    await Future.delayed(_delay);
    _mustLoggedIn();

    return;
  }

  Future<void> commentUnsave(Comment comment) async {
    _log.info('commentUnsave(${comment.id})');
    await Future.delayed(_delay);
    _mustLoggedIn();
    return;
  }

  Future<User?> currentUser() async {
    _log.info('currentUser()');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('user.current.info.json');
    final json = jsonDecode(data);
    json['name'] = json['name'] + '_' + Random().nextInt(1000).toString();
    return User.fromJson(json);
  }

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

  // Future<String> subredditIcon(Subreddit subreddit) async {
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
    final data = await _readFile('search.json');

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
    final data = await _readFile('subreddits.search.json');
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => Subreddit.fromJson(v))
        .take(limit)
        .toList();
  }

  Future<List<Subreddit>> searchSubredditsByName(String query) async {
    _log.info('searchSubredditsByName($query)');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('subreddits.search.by.name.json');
    return (jsonDecode(data) as List<dynamic>)
        .map((v) => Subreddit.fromJson(v))
        .toList();
  }

  Future<Comment> submissionReply(Submission submission, String body) async {
    _log.info('submissionReply(${submission.id}, $body)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return Comment.fromJson({'body': body});
  }

  Future<Comment> commentReply(Comment comment, String body) async {
    _log.info('commentReply(${comment.id}, $body)');
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
    final data = await _readFile('inbox.messages.json');

    return (jsonDecode(data) as List<dynamic>)
        .map((v) => Message.fromJson(v))
        .toList();
  }

  Future<void> userBlock(User user) async {
    _log.info('userBlock(${user.name})');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return;
  }

  Future<void> userUnblock(User user) async {
    _log.info('userUnblock(${user.name})');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return;
  }

  Future<void> submissionReport(Submission submission, String reason) async {
    _log.info('submissionReport(${submission.id}, $reason)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return;
  }

  Future<void> commentReport(Comment comment, String reason) async {
    _log.info('commentReport(${comment.id}, $reason)');
    _mustLoggedIn();
    await Future.delayed(_delay);
    return;
  }

  Future<List<Rule>> subredditRules(Subreddit subreddit) async {
    _log.info('subredditRules(${subreddit.name})');
    await Future.delayed(_delay);
    _mustLoggedIn();
    final data = await _readFile('subreddit.2.rules.json');
    return parseRules(jsonDecode(data))!;
  }
}
