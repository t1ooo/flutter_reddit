import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../logging/logging.dart';
import '../reddit_api/comment.dart';
import '../reddit_api/like.dart';
import '../reddit_api/message.dart';
import '../reddit_api/preview_images.dart';
import '../reddit_api/reddir_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import '../reddit_api/subreddit.dart';
import '../reddit_api/trophy.dart';
import '../reddit_api/user.dart';

abstract class Savable {
  Future<void> save() async {
    if (saved) {
      return;
    }
    return _updateSave(true);
  }

  Future<void> unsave() async {
    if (!saved) {
      return;
    }
    return _updateSave(false);
  }

  Future<void> _updateSave(bool saved);

  bool get saved;
}

abstract class Likable {
  Like get likes;
  int get score;

  Future<void> like() async {
    if (likes == Like.up) {
      return _updateLike(Like.none);
    }
    return await _updateLike(Like.up);
  }

  Future<void> dislike() async {
    if (likes == Like.down) {
      return _updateLike(Like.none);
    }
    return await _updateLike(Like.down);
  }

  Future<void> _updateLike(Like like);
}

class SearchNotifier extends ChangeNotifier with TryMixin {
  SearchNotifier(this._redditApi);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = getLogger('SearchNotifierX');

  void reset() {
    _subredditName = '';
    _query = '';
    _sort = Sort.relevance;
    _submissions = null;
    notifyListeners();
  }

  String _subredditName = '';
  String _query = '';

  Sort _sort = Sort.relevance;
  Sort get sort => _sort;

  List<Sort> get sorts => Sort.values;

  List<SubmissionNotifier>? _submissions;
  List<SubmissionNotifier>? get submissions => _submissions;

  Future<void> reloadSearch() {
    _submissions = null;
    return search(_query, _sort, _subredditName);
  }

  Future<void> search(
    String query, [
    Sort sort = Sort.relevance,
    String subredditName = 'all',
  ]) {
    return _try(() async {
      if (_submissions != null &&
          _query == query &&
          _sort == sort &&
          _subredditName == subredditName) return;

      _query = query;
      _sort = sort;
      _subredditName = subredditName;

      _submissions = (await _redditApi
              .search(query,
                  limit: _limit, sort: _sort, subreddit: _subredditName)
              .toList())
          .map((v) => SubmissionNotifier(_redditApi, v))
          .toList();
      notifyListeners();
    }, 'fail to search');
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

// TODO: rename
class SearchSubredditsQ extends ChangeNotifier with TryMixin {
  SearchSubredditsQ(this._redditApi);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = getLogger('SearchSubredditsQ');

  void reset() {
    _query = '';
    _subreddits = null;
    notifyListeners();
  }

  String _query = '';

  List<SubredditNotifier>? _subreddits;
  List<SubredditNotifier>? get subreddits => _subreddits;

  Future<void> reloadSearch() {
    _subreddits = null;
    return search(_query);
  }

  Future<void> search(String query) {
    return _try(() async {
      if (_subreddits != null && _query == query) return;
      _query = query;

      _subreddits =
          (await _redditApi.searchSubreddits(query, limit: _limit).toList())
              .map((v) => SubredditNotifier(_redditApi, v))
              .toList();
      notifyListeners();
    }, 'fail to search subreddits');
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

class SubmissionLoaderNotifier extends ChangeNotifier with TryMixin {
  SubmissionLoaderNotifier(this._redditApi);

  final RedditApi _redditApi;
  static final _log = getLogger('SubmissionLoaderNotifier');

  void reset() {
    _id = null;
    _submission = null;
    notifyListeners();
  }

  String? _id;

  SubmissionNotifier? _submission;
  SubmissionNotifier? get submission => _submission;

  Future<void> loadSubmission(String id) {
    return _try(() async {
      if (_submission != null && _id == id) return;
      _id = id;

      _submission =
          SubmissionNotifier(_redditApi, await _redditApi.submission(_id!));
      notifyListeners();
    }, 'fail to load submission');
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

class SubredditLoaderNotifier extends ChangeNotifier with TryMixin {
  SubredditLoaderNotifier(this._redditApi);

  final RedditApi _redditApi;
  static final _log = getLogger('SubredditNotifier');

  void reset() {
    _name = null;
    _subreddit = null;
    notifyListeners();
  }

  String? _name;

  SubredditNotifier? _subreddit;
  SubredditNotifier? get subreddit => _subreddit;

  Future<void> loadSubreddit(String name) {
    return _try(() async {
      if (_subreddit != null && _name == name) return;
      _name = name;

      _subreddit =
          SubredditNotifier(_redditApi, await _redditApi.subreddit(_name!));
      notifyListeners();
    }, 'fail to load subreddit');
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

class SubredditNotifier extends SubmissionsNotifier<SubType>
    with PropertyListener {
  SubredditNotifier(
    this._redditApi,
    this._subreddit, [
    this.isUserSubreddit = false,
  ]) : super(_redditApi, SubType.values.first);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = getLogger('SubredditNotifier');

  final bool isUserSubreddit;

  String get name => _subreddit.displayName;
  Subreddit _subreddit;
  Subreddit get subreddit => _subreddit;

  Future<void> subscribe() {
    return _try(() async {
      if (_subreddit.userIsSubscriber) return;
      await _redditApi.subredditSubscribe(name);
      _subreddit = _subreddit.copyWith(userIsSubscriber: true);
      notifyListeners();
    }, 'fail to subscribe');
  }

  Future<void> unsubscribe() {
    return _try(() async {
      if (!(_subreddit.userIsSubscriber)) return;
      await _redditApi.subredditSubscribe(name);
      _subreddit = _subreddit.copyWith(userIsSubscriber: false);
      notifyListeners();
    }, 'fail to unsubscribe');
  }

  Future<void> favorite() {
    return _try(() async {
      if (_subreddit.userHasFavorited) return;
      await _redditApi.subredditFavorite(name);
      _subreddit = _subreddit.copyWith(userHasFavorited: true);
      notifyListeners();
    }, 'fail to favorite');
  }

  Future<void> unfavorite() {
    return _try(() async {
      if (!(_subreddit.userHasFavorited)) return;
      await _redditApi.subredditUnfavorite(name);
      _subreddit = _subreddit.copyWith(userHasFavorited: false);
      notifyListeners();
    }, 'fail to unfavorite');
  }

  @override
  Stream<Submission> _loadSubmissions() {
    return _redditApi.subredditSubmissions(name, limit: _limit, type: _subType);
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
    return _try(() async {
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

abstract class SubmissionsNotifier<T> extends ChangeNotifier with TryMixin {
  SubmissionsNotifier(this._redditApi, this._initialSubType)
      : _subType = _initialSubType;

  final RedditApi _redditApi;

  int _limit = 10;

  void reset() {
    _submissions = null;
    _subType = _initialSubType;
    notifyListeners();
  }

  T _initialSubType;
  T _subType;
  T get subType => _subType;

  List<SubmissionNotifier>? _submissions;
  List<SubmissionNotifier>? get submissions => _submissions;

  Future<void> reloadSubmissions() {
    _submissions = null;
    return loadSubmissions(_subType);
  }

  Future<void> loadSubmissions(T subType) {
    return _try(() async {
      if (_submissions != null && _subType == subType) return;
      _subType = subType;

      _submissions = (await _loadSubmissions().toList())
          .map((v) => SubmissionNotifier(_redditApi, v))
          .toList();
      notifyListeners();
    }, 'fail to search');
  }

  Stream<Submission> _loadSubmissions();
}

// TODO: move to current user
class HomeFrontNotifier extends SubmissionsNotifier<FrontSubType> {
  HomeFrontNotifier(RedditApi redditApi)
      : super(redditApi, FrontSubType.values.first);

  static final _log = getLogger('HomeFrontNotifier');

  @override
  Stream<Submission> _loadSubmissions() {
    return _redditApi.front(limit: _limit, type: _subType);
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

class HomePopularNotifier extends SubmissionsNotifier<SubType> {
  HomePopularNotifier(RedditApi redditApi)
      : super(redditApi, SubType.values.first);

  static final _log = getLogger('HomeFrontNotifier');

  @override
  Stream<Submission> _loadSubmissions() {
    return _redditApi.popular(limit: _limit, type: _subType);
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

class PreviewImage {
  final PreviewItem image;
  final PreviewItem preview;
  PreviewImage(this.image, this.preview);
}

class SubmissionNotifier extends ChangeNotifier
    with TryMixin, Likable, Savable, PropertyListener {
  SubmissionNotifier(this._redditApi, this._submission) {
    _setComments(_submission.comments);
  }

  final RedditApi _redditApi;
  static final _log = getLogger('SubmissionNotifier');

  List<CommentNotifier>? _comments;
  List<CommentNotifier>? get comments => _comments;

  Submission _submission;
  Submission get submission => _submission;

  int get numReplies {
    return (_comments == null)
        ? _submission.numComments
        : _comments!.map((v) => 1 + v.numReplies).sum();
  }

  Future<void> reloadSubmission() {
    _comments = null;
    return _loadSubmission();
  }

  Future<void> _loadSubmission() {
    return _try(() async {
      if (_comments != null) return;
      _submission = await _redditApi.submission(_submission.id);
      _setComments(_submission.comments);
      notifyListeners();
    }, 'fail to load comments');
  }

  Future<void> loadComments() {
    return _loadSubmission();
  }

  void _setComments(List<Comment>? comments) {
    _comments = comments?.map((v) {
      return _addListener(CommentNotifier(_redditApi, v));
    }).toList();
  }

  Future<void> reply(String body) {
    return _try(() async {
      final commentReply =
          await _redditApi.submissionReply(submission.id, body);

      _comments ??= [];
      _comments!
          .insert(0, _addListener(CommentNotifier(_redditApi, commentReply)));
      notifyListeners();
    }, 'fail to reply');
  }

  CommentNotifier _addListener(CommentNotifier t) {
    return t..addPropertyListener<int>(() => t.numReplies, notifyListeners);
  }

  // TODO: save unsave
  Future<void> save() {
    return _updateSave(true);
  }

  bool get saved => _submission.saved;

  Future<void> _updateSave(bool saved) {
    return _try(() async {
      await (saved
          ? _redditApi.submissionSave
          : _redditApi.submissionUnsave)(submission.id);
      _submission = submission.copyWith(saved: saved);
      notifyListeners();
    }, 'fail to' + (saved ? 'save' : 'unsave'));
  }

  @override
  Like get likes => _submission.likes;

  @override
  int get score => _submission.score;

  Future<void> _updateLike(Like like) {
    _log.info('_updateLike($like)');

    return _try(() async {
      await _redditApi.submissionLike(submission.id, like);
      _submission = submission.copyWith(
        likes: like,
        score: calcScore(submission.score, submission.likes, like),
      );
      notifyListeners();
    }, 'fail to like');
  }

  Future<void> share() {
    return _try(() async {
      await Share.share('${submission.title} ${submission.shortLink}');
    }, 'fail to share');
  }

  // TODO: add height
  List<PreviewImage> images([
    double maxWidth = double.infinity,
    double maxHeight = double.infinity,
  ]) {
    return _submission.preview
        .map(
          (v) {
            final resolutions = [v.source, ...v.resolutions.reversed];
            resolutions.sort((a, b) => (b.width - a.width).toInt());

            for (final img in resolutions) {
              if (img.width <= maxWidth && img.width <= maxHeight) {
                return PreviewImage(v.source, img);
              }
            }

            return PreviewImage(v.source, v.source);
          },
        )
        .whereType<PreviewImage>()
        .toList();
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

class CommentNotifier
    with
        TryMixin,
        CollapseMixin,
        ChangeNotifier,
        Likable,
        Savable,
        PropertyListener {
  CommentNotifier(this._redditApi, this._comment) {
    _replies = _comment.replies
        .map((v) => _addListener(CommentNotifier(_redditApi, v)))
        .toList();
  }

  final RedditApi _redditApi;

  static final _log = getLogger('CommentNotifier');

  Comment _comment;
  Comment get comment => _comment;

  late final List<CommentNotifier> _replies;
  List<CommentNotifier> get replies => _replies;

  int get numReplies {
    return (_replies.isEmpty)
        ? _comment.numComments
        : _replies.map((v) => 1 + v.numReplies).sum();
  }

  Future<void> copyText() {
    return _try(() {
      return Clipboard.setData(ClipboardData(text: _comment.body));
    }, 'fail to copy');
  }

  bool get saved => _comment.saved;

  Future<void> _updateSave(bool saved) {
    return _try(() async {
      await (saved
          ? _redditApi.commentSave
          : _redditApi.commentUnsave)(comment.id);
      _comment = comment.copyWith(saved: saved);
      notifyListeners();
    }, 'fail to ' + (saved ? 'save' : 'unsave'));
  }

  @override
  Like get likes => _comment.likes;

  @override
  int get score => _comment.score;

  Future<void> _updateLike(Like like) {
    _log.info('_updateLike($like)');
    return _try(() async {
      await _redditApi.commentLike(comment.id, like);
      _comment = comment.copyWith(
        likes: like,
        score: calcScore(comment.score, comment.likes, like),
      );
      notifyListeners();
    }, 'fail to like');
  }

  Future<void> share() {
    return _try(() async {
      await Share.share('${_comment.linkTitle} ${_comment.shortLink}');
    }, 'fail to share');
  }

  Future<void> reply(String body) async {
    return _try(() async {
      final commentReply = await _redditApi.commentReply(_comment.id, body);

      _replies.insert(0, CommentNotifier(_redditApi, commentReply));
      notifyListeners();
    }, 'fail to reply');
  }

  CommentNotifier _addListener(CommentNotifier t) {
    return t
      ..addPropertyListener<int>(() => t.numReplies, () {
        print('update');
        notifyListeners();
      });
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

class UserLoaderNotifier extends ChangeNotifier with TryMixin {
  UserLoaderNotifier(this._redditApi);

  final RedditApi _redditApi;

  static final _log = getLogger('UserLoaderNotifier');

  void reset() {
    _name = null;
    _user = null;
    notifyListeners();
  }

  String? _name;

  UserNotifier? _user;
  UserNotifier? get user => _user;

  Future<void> loadUser(String name) {
    return _try(() async {
      if (_user != null && _name == name) return;
      _name = name;

      _user = UserNotifier(_redditApi, await _redditApi.user(_name!));

      notifyListeners();
    }, 'fail to load user');
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

class UserNotifier extends ChangeNotifier with TryMixin {
  UserNotifier(this._redditApi, this._user, [this.isCurrentUser = false])
      : _name = _user.name,
        _subreddit = SubredditNotifier(_redditApi, _user.subreddit, true);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = getLogger('UserNotifier');

  final bool isCurrentUser;

  final String _name;

  final SubredditNotifier _subreddit;
  SubredditNotifier get subreddit => _subreddit;

  User _user;
  User get user => _user;

  List<SubmissionNotifier>? _submissions;
  List<SubmissionNotifier>? get submissions => _submissions;

  Future<void> reloadSubmissions() {
    _submissions = null;
    return loadSubmissions();
  }

  Future<void> loadSubmissions() {
    return _try(() async {
      if (_submissions != null) return;
      _submissions =
          (await _redditApi.userSubmissions(_name, limit: _limit).toList())
              .map((v) => SubmissionNotifier(_redditApi, v))
              .toList();
      notifyListeners();
    }, 'fail to load user submissions');
  }

  List<CommentNotifier>? _comments;
  List<CommentNotifier>? get comments => _comments;

  Future<void> reloadComments() {
    _comments = null;
    return loadComments();
  }

  Future<void> loadComments() {
    return _try(() async {
      if (_comments != null) return;
      _comments = (await _redditApi.userComments(_name, limit: _limit).toList())
          .map((v) => CommentNotifier(_redditApi, v))
          .toList();
      notifyListeners();
    }, 'fail to load user comments');
  }

  List<Trophy>? _trophies;
  List<Trophy>? get trophies => _trophies;
  Future<void> loadTrophies() {
    return _try(() async {
      if (_trophies != null) return;
      _trophies = await _redditApi.userTrophies(_name);
      notifyListeners();
    }, 'fail to load user comments');
  }

  List<CommentNotifier>? _savedComments;
  List<CommentNotifier>? get savedComments =>
      _savedComments?.where((v) => v.comment.saved).toList();
  List<SubmissionNotifier>? _savedSubmissions;
  List<SubmissionNotifier>? get savedSubmissions =>
      _savedSubmissions?.where((v) => v.submission.saved).toList();

  Future<void> reloadSaved() {
    _savedComments = null;
    return loadSaved();
  }

  Future<void> loadSaved() {
    return _try(() async {
      if (_savedComments != null && _savedSubmissions != null) return;
      final saved = await _redditApi.userSaved(_user.name, limit: _limit);
      _savedSubmissions = saved.submissions
          .map((v) => SubmissionNotifier(_redditApi, v))
          .toList();
      _savedComments =
          saved.comments.map((v) => CommentNotifier(_redditApi, v)).toList();
      notifyListeners();
    }, 'fail to load saved');
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

// TODO: rename to AuthNotifier
// TODO: merge with CurrentUserNotifier?
class UserAuth extends ChangeNotifier with TryMixin {
  UserAuth(this._redditApi);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = getLogger('UserAuth');

  CurrentUserNotifier? _user;
  CurrentUserNotifier? get user => _user;

  Future<bool> loginSilently(String name, String pass) async {
    return _try<bool>(() async {
      if (_redditApi.isLoggedIn) {
        return true;
      }
      if (await _redditApi.loginSilently()) {
        await _loadUser();
        notifyListeners();
        return true;
      }
      return false;
    }, 'fail to login silently');
  }

  // TODO: remove args
  Future<void> login(String name, String pass) {
    return _try(() async {
      if (_redditApi.isLoggedIn) {
        return;
      }
      await _redditApi.login();
      await _loadUser();
      notifyListeners();
    }, 'fail to login');
  }

  Future<void> _loadUser() async {
    final user = await _redditApi.currentUser();
    if (user == null) {
      throw Exception('user is null');
    }
    _user = CurrentUserNotifier(_redditApi, user);
  }

  Future<void> logout() {
    return _try(() async {
      if (!_redditApi.isLoggedIn) {
        return;
      }
      await _redditApi.logout();
      _user = null;
      notifyListeners();
    }, 'fail to logout');
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

class CurrentUserNotifier extends UserNotifier with PropertyListener {
  CurrentUserNotifier(this._redditApi, User user)
      : super(_redditApi, user, true);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = getLogger('CurrentUserNotifier');

  SubredditNotifier? _all;
  SubredditNotifier? get all => _all;

  List<SubredditNotifier>? _subreddits;
  List<SubredditNotifier>? get subreddits => _subreddits;

  Future<void> reloadSubreddits() {
    _all = null;
    _subreddits = null;
    return loadSubreddits();
  }

  Future<void> loadSubreddits() {
    return _try(() async {
      _loadSubredditAll();
      _loadSubreddits();
    }, 'fail to load subreddits');
  }

  Future<void> _loadSubredditAll() async {
    if (_all != null) {
      return;
    }
    _all = _addListener(
        SubredditNotifier(_redditApi, await _redditApi.subreddit('all')));
    notifyListeners();
  }

  Future<void> _loadSubreddits() async {
    if (_subreddits != null) {
      return;
    }
    _subreddits = await _redditApi
        .currentUserSubreddits(limit: _limit)
        .map((v) => _addListener(SubredditNotifier(_redditApi, v)))
        .toList();
    notifyListeners();
  }

  SubredditNotifier _addListener(SubredditNotifier t) {
    return t
      ..addPropertyListener<bool>(() => t.subreddit.userHasFavorited, () {
        print('update');
        notifyListeners();
      });
  }

  static List<SubredditNotifier> filterFavorite(
          List<SubredditNotifier> subreddits) =>
      subreddits.where((v) => v.subreddit.userHasFavorited).toList();

  static List<SubredditNotifier> filterUnfavorite(
          List<SubredditNotifier> subreddits) =>
      subreddits.where((v) => !v.subreddit.userHasFavorited).toList();

  List<MessageNotifier>? _inboxMessages;
  List<MessageNotifier>? get inboxMessages => _inboxMessages;

  Future<void> reloadInboxMessages() {
    _inboxMessages = null;
    return loadInboxMessages();
  }

  Future<void> loadInboxMessages() {
    return _try(() async {
      if (_inboxMessages != null) {
        return;
      }
      _inboxMessages = await _redditApi
          .inboxMessages()
          .map((v) => MessageNotifier(_redditApi, v))
          .toList();
      notifyListeners();
    }, 'fail to load inbox messages');
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

class MessageNotifier extends ChangeNotifier with TryMixin {
  MessageNotifier(this._redditApi, this._message);

  final RedditApi _redditApi;
  static final _log = getLogger('MessageNotifier');

  Message _message;
  Message get message => _message;

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

class UIException implements Exception {
  UIException(this._message);
  String _message;
  String toString() => _message;
}

mixin TryMixin {
  static final _log = getLogger('TryMixin');

  Future<T> _try<T>(Future<T> Function() fn, String error) async {
    try {
      return await fn();
    } on Exception catch (e, st) {
      _log.error('', e, st);
      throw UIException(error);
    }
  }
}

mixin CollapseMixin {
  bool _collapsed = false;

  bool get expanded => !_collapsed;
  bool get collapsed => _collapsed;

  void collapse() {
    if (_collapsed) return;
    _collapsed = true;
    notifyListeners();
  }

  void expand() {
    if (!_collapsed) return;
    _collapsed = false;
    notifyListeners();
  }

  void notifyListeners() {
    throw UnimplementedError();
  }
}

int calcScore(int score, Like oldLike, Like newLike) {
  if (oldLike == Like.up) {
    if (newLike == Like.down) {
      return score - 2;
    } else if (newLike == Like.none) {
      return score - 1;
    }
  } else if (oldLike == Like.none) {
    if (newLike == Like.down) {
      return score - 1;
    } else if (newLike == Like.up) {
      return score + 1;
    }
  } else if (oldLike == Like.down) {
    if (newLike == Like.up) {
      return score + 2;
    } else if (newLike == Like.none) {
      return score + 1;
    }
  }
  return score;
}

class ListNotifier<T extends ChangeNotifier> extends ChangeNotifier {
  ListNotifier(this._values) {
    for (final value in _values) {
      value.addListener(() {
        notifyListeners();
      });
    }
  }

  UnmodifiableListView<T> get values => UnmodifiableListView(_values);
  List<T> _values;
}

mixin PropertyListener on ChangeNotifier {
  void addPropertyListener<T>(T Function() select, void Function() listener) {
    T value = select();
    addListener(() {
      final newValue = select();
      print([value, newValue]);
      if (value == newValue) {
        return;
      }
      value = newValue;
      listener();
    });
  }
}

extension IterableSum<T extends num> on Iterable<T> {
  T sum() {
    return this.reduce((r, v) => r + v as T);
  }
}
