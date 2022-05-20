import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:share_plus/share_plus.dart';

import '../logging/logging.dart';
import '../reddit_api/reddit_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import '../reddit_api/subreddit.dart';
import 'limit.dart';
import 'property_listener.dart';
import 'rule_notifier.dart';
import 'submission_notifier.dart';
import 'submissions_notifier.dart';

class SubredditNotifier extends SubmissionsNotifier<SubType> {
  SubredditNotifier(
    this._redditApi,
    this._subreddit, [
    this.isUserSubreddit = false,
  ]) : super(_redditApi, SubType.values.first);

  final RedditApi _redditApi;

  static final _log = getLogger('SubredditNotifier');

  final bool isUserSubreddit;

  String get name => _subreddit.displayName; // TODO: remove
  Subreddit _subreddit;
  Subreddit get subreddit => _subreddit;

  Future<void> subscribe() {
    return try_(() async {
      if (_subreddit.userIsSubscriber) return;
      await _redditApi.subredditSubscribe(name);
      _subreddit = _subreddit.copyWith(userIsSubscriber: true);
      notifyListeners();
    }, 'fail to subscribe');
  }

  Future<void> unsubscribe() {
    return try_(() async {
      if (!(_subreddit.userIsSubscriber)) return;
      await _redditApi.subredditSubscribe(name);
      _subreddit = _subreddit.copyWith(userIsSubscriber: false);
      notifyListeners();
    }, 'fail to unsubscribe');
  }

  Future<void> favorite() {
    return try_(() async {
      if (_subreddit.userHasFavorited) return;
      await _redditApi.subredditFavorite(name);
      _subreddit = _subreddit.copyWith(userHasFavorited: true);
      notifyListeners();
    }, 'fail to favorite');
  }

  Future<void> unfavorite() {
    return try_(() async {
      if (!(_subreddit.userHasFavorited)) return;
      await _redditApi.subredditUnfavorite(name);
      _subreddit = _subreddit.copyWith(userHasFavorited: false);
      notifyListeners();
    }, 'fail to unfavorite');
  }

  Future<void> share() {
    return try_(() async {
      await Share.share('${_subreddit.title} ${_subreddit.shortLink}');
    }, 'fail to share');
  }

  @override
  Future<List<Submission>> loadSubmissions_() {
    return _redditApi.subredditSubmissions(name, limit: limit, type: subType);
  }

  Future<SubmissionNotifier> submit({
    required String title,
    String? selftext,
    String? url,
    bool resubmit = true,
    bool sendReplies = true,
    bool nsfw = false,
    bool spoiler = false,
  }) async {
    return try_(() async {
      final submission = await _redditApi.submit(
        subreddit: _subreddit.displayName,
        title: title,
        selftext: selftext,
        url: url,
        resubmit: resubmit,
        sendReplies: sendReplies,
        nsfw: nsfw,
        spoiler: spoiler,
      );
      return SubmissionNotifier(_redditApi, submission);
    }, 'fail to submit');
  }

  List<RuleNotifier>? _rules;
  List<RuleNotifier>? get rules => _rules;

  Future<void> reloadRules() {
    _rules = null;
    return loadRules();
  }

  Future<void> loadRules() {
    return try_(() async {
      if (_rules != null) return;
      _rules = (await _redditApi.subredditRules(_subreddit.displayName))
          .map((v) => RuleNotifier(v))
          .toList();
      notifyListeners();
    }, 'fail to load rules');
  }

  // TODO
  Future<void> loadAbout() => throw UnimplementedError();
  Object? _about;
  get about => _about;

  // TODO
  Future<void> loadMenu() => throw UnimplementedError();
  Object? _menu;
  get menu => _menu;

  // TODO
  Future<void> loadWiki() => throw UnimplementedError();
  Object? _wiki;
  get wiki => _wiki;

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}
