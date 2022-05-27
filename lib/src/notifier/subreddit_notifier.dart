import 'package:share_plus/share_plus.dart';

import '../reddit_api/reddit_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import '../reddit_api/subreddit.dart';
import 'const.dart';
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

  final bool isUserSubreddit;

  String get name => _subreddit.displayName;

  Subreddit _subreddit;
  Subreddit get subreddit => _subreddit;

  Future<void> subscribe(bool subscribe) {
    return try_(
      () async {
        if (_subreddit.userIsSubscriber == subscribe) return;
        await _redditApi.subredditSubscribe(_subreddit, subscribe);
        _subreddit = _subreddit.copyWith(userIsSubscriber: subscribe);
        notifyListeners();
      },
      'fail to${subscribe ? 'subscribe' : 'unsubscribe'}',
    );
  }

  Future<void> favorite(bool favorite) {
    return try_(
      () async {
        if (_subreddit.userHasFavorited == favorite) return;
        await _redditApi.subredditFavorite(_subreddit, favorite);
        _subreddit = _subreddit.copyWith(userHasFavorited: favorite);
        notifyListeners();
      },
      'fail to${favorite ? 'favorite' : 'unfavorite'}',
    );
  }

  Future<void> share() {
    return try_(
      () async {
        await Share.share('${_subreddit.title} ${_subreddit.shortLink}');
      },
      'fail to share',
    );
  }

  @override
  Future<List<Submission>> loadSubmissions_() {
    return _redditApi.subredditSubmissions(
      _subreddit,
      limit: limit,
      type: subType,
    );
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
    return try_(
      () async {
        final submission = await _redditApi.submit(
          subreddit: name,
          title: title,
          selftext: selftext,
          url: url,
          resubmit: resubmit,
          sendReplies: sendReplies,
          nsfw: nsfw,
          spoiler: spoiler,
        );
        return SubmissionNotifier(_redditApi, submission);
      },
      'fail to submit',
    );
  }

  List<RuleNotifier>? _rules;
  List<RuleNotifier>? get rules => _rules;

  Future<void> reloadRules() {
    _rules = null;
    return loadRules();
  }

  Future<void> loadRules() {
    return try_(
      () async {
        if (_rules != null) return;
        _rules = (await _redditApi.subredditRules(_subreddit))
            .map((v) => RuleNotifier(v))
            .toList();
        notifyListeners();
      },
      'fail to load rules',
    );
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
}
