import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

import '../logging/logging.dart';
import '../reddit_api/reddir_api.dart';
import '../reddit_api/submission_type.dart';
import '../reddit_api/trophy.dart';
import '../reddit_api/user.dart';
import '../reddit_api/comment.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/subreddit.dart';
import '../reddit_api/vote.dart';

// TODO: _try
class SearchNotifierQ extends ChangeNotifier {
  SearchNotifierQ(this._redditApi);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = Logger('SearchNotifierQX');

  String _subredditName = '';
  // String get subredditName => _subredditName;

  String _query = '';
  // String get query => query;

  Sort _sort = Sort.relevance;
  Sort get sort => _sort;

  List<Sort> get sorts => Sort.values;

  List<SubmissionNotifierQ>? _submissions;
  List<SubmissionNotifierQ>? get submissions => _submissions;

  Future<String?> search(
    String query, [
    Sort sort = Sort.relevance,
    String subredditName = 'all',
  ]) {
    // _query = query;
    // _sort = sort;
    // _subredditName = subredditName;
    // _submissions = null;
    // notifyListeners();

    // try {
    //   _submissions =
    //       (await _redditApi.search(_query, limit: _limit, sort: _sort).toList())
    //           .map((v) => SubmissionNotifierQ(_redditApi, v))
    //           .toList();
    //   notifyListeners();
    //   return null;
    // } on Exception catch (e, st) {
    //   _log.error('', e, st);
    //   return 'Error: fail to search';
    // }

    return _try(() async {
      if (_submissions != null &&
          _query == query &&
          _sort == sort &&
          _subredditName == subredditName) return null;

      _query = query;
      _sort = sort;
      _subredditName = subredditName;

      _submissions = (await _redditApi
              .search(query,
                  limit: _limit, sort: _sort, subreddit: _subredditName)
              .toList())
          .map((v) => SubmissionNotifierQ(_redditApi, v))
          .toList();

      return null;
    }, 'Error: fail to search');
  }

  Future<String?> _try(Future<String?> Function() fn, String error) async {
    try {
      return await fn();
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return error;
    }
  }
}

class SubredditNotifierQ extends ChangeNotifier {
  SubredditNotifierQ(this._redditApi);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = Logger('SubredditNotifierQ');

  // set name(name);

  String? _name;
  Subreddit? _subreddit;
  Subreddit? get subreddit => _subreddit;

  void _reset() {
    _subreddit = null;
    _submissions = null;
    _about = null;
    _menu = null;
    _wiki = null;
  }

  void _setName(String name) {
    if (_name != name) _reset();
    _name = name;
  }

  // Future<String?> loadSubreddit(String name) {
  //   return _try(() async {
  //     if (_subreddit != null && _name == name) return null;
  //     _name = name;
  //     _subreddit = await _redditApi.subreddit(_name!);
  //     return null;
  //   }, 'Error: fail to load subreddit');
  // }
  Future<String?> loadSubreddit(String name) {
    return _try(() async {
      _setName(name);
      if (_subreddit != null) return null;
      _subreddit = await _redditApi.subreddit(_name!);
      notifyListeners();
      return null;
    }, 'Error: fail to load subreddit');
  }

  Future<String?> subscribe() {
    return _try(() async {
      if (_subreddit!.userIsSubscriber) return;
      await _redditApi.subscribe(_name!);
      _subreddit = _subreddit!.copyWith(userIsSubscriber: true);
      notifyListeners();
      return null;
    }, 'Error: fail to subscribe');
  }

  Future<String?> unsubscribe() {
    return _try(() async {
      if (!(_subreddit!.userIsSubscriber)) return;
      await _redditApi.subscribe(_name!);
      _subreddit = _subreddit!.copyWith(userIsSubscriber: false);
      notifyListeners();
      return null;
    }, 'Error: fail to unsubscribe');
  }

  SubType _subType = SubType.best;
  SubType get subType => _subType;

  List<SubmissionNotifierQ>? _submissions;
  List<SubmissionNotifierQ>? get submissions => _submissions;

  Future<String?> loadSubmissions(SubType subType) {
    print('loadSubmissions');
    return _try(() async {
      if (_submissions != null && _subType == subType) return null;
      _subType = subType;
      _submissions = await _redditApi
          .subredditSubmissions(_name!, limit: _limit, type: _subType)
          .map((v) => SubmissionNotifierQ(_redditApi, v))
          .toList();
      notifyListeners();
      return null;
    }, 'Error: fail to load subreddit submissions');
  }

  // TODO
  Future<String?> loadAbout() => throw UnimplementedError();
  Object? _about;
  get about => _about;

  // TODO
  Future<String?> loadMenu() => throw UnimplementedError();
  Object? _menu;
  get menu => _menu;

  // TODO
  Future<String?> loadWiki() => throw UnimplementedError();
  Object? _wiki;
  get wiki => _wiki;

  // TODO
  Future<String?> star() => throw UnimplementedError();
  // TODO
  Future<String?> unstar() => throw UnimplementedError();

  Future<String?> _try(Future<String?> Function() fn, String error) async {
    try {
      return await fn();
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return error;
    }
  }
}

class HomeFrontNotifierQ extends ChangeNotifier {
  HomeFrontNotifierQ(this._redditApi);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = Logger('HomeFrontNotifierQ');

  SubType _subType = SubType.best;
  SubType get subType => _subType;

  List<SubmissionNotifierQ>? _submissions;
  List<SubmissionNotifierQ>? get submissions => _submissions;

  Future<String?> loadSubmissions(SubType subType) async {
    if (_subType == subType) return null;
    _subType = subType;

    try {
      _submissions =
          (await _redditApi.front(limit: _limit, type: _subType).toList())
              .map((v) => SubmissionNotifierQ(_redditApi, v))
              .toList();
      notifyListeners();
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return 'Error: fail to search';
    }
  }
}

class HomePopularNotifierQ extends ChangeNotifier {
  HomePopularNotifierQ(this._redditApi);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = Logger('HomePopularNotifierQ');

  SubType _subType = SubType.best;
  SubType get subType => _subType;

  List<SubmissionNotifierQ>? _submissions;
  List<SubmissionNotifierQ>? get submissions => _submissions;

  Future<String?> loadSubmissions(SubType subType) async {
    if (_subType == subType) return null;
    _subType = subType;

    try {
      _submissions =
          (await _redditApi.popular(limit: _limit, type: _subType).toList())
              .map((v) => SubmissionNotifierQ(_redditApi, v))
              .toList();
      notifyListeners();
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return 'Error: fail to search';
    }
  }
}

class SubmissionNotifierQ extends ChangeNotifier {
  SubmissionNotifierQ(this._redditApi, [this._submission]) {
    _id = _submission?.id;
    _setComments(_submission?.comments);
  }

  String? _id;

  final RedditApi _redditApi;
  static final _log = Logger('SubmissionNotifierQ');

  List<CommentNotifierQ>? _comments;
  List<CommentNotifierQ>? get comments => _comments;

  Submission? _submission;
  Submission? get submission => _submission;

  // set submission(Submission? s) {
  //   if (_submission == s) return null;

  //   _submission = s;
  //   _id = _submission?.id;
  //   _comments = _submission?.comments.map((v) {
  //     return CommentNotifierQ(_redditApi, v);
  //   }).toList();

  //   notifyListeners();
  // }

  void _setComments(List<Comment>? comments) {
    _comments = comments?.map((v) {
      return CommentNotifierQ(_redditApi, v);
    }).toList();
  }

  Future<String?> loadSubmission(String id) async {
    if (_id == id) return null;
    _id = id;
    print('loadSubmission');
    return reloadSubmission();
  }

  Future<String?> reloadSubmission() async {
    try {
      _submission = await _redditApi.submission(_id!);
      _setComments(_submission?.comments);
      notifyListeners();
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return _formatError('load');
    }
  }

  /* Future<Result?> loadSubmission(String id) async {
    if (_id  == id) return Reload();
    _id = id;
    print('loadSubmission');
    return reloadSubmission();
  }

  Future<Result?> reloadSubmission() async {
    try {
      _submission = await _redditApi.submission(_id!);
      _setComments(_submission?.comments);
      notifyListeners();
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return Error('fail to load');
    }
  } */

  Future<String?> reply(String body) async {
    final s = submission!;

    try {
      final commentReply = await _redditApi.submissionReply(s.id, body);
      // _comments!.add(CommentNotifierQ(_redditApi, commentReply));
      if (_comments == null) {
        _comments = [];
      }
      _comments!.insert(0, CommentNotifierQ(_redditApi, commentReply));
      notifyListeners();
      return null;
    } on Exception catch (e) {
      _log.error(e);
      return _formatError('reply');
    }
  }

  // TODO: save unsave
  Future<String?> save() async {
    final s = submission!;

    if (s.saved) return null;

    try {
      await _redditApi.submissionSave(s.id);
      _submission = s.copyWith(saved: true);
      notifyListeners();
      return 'Saved';
    } on Exception catch (e) {
      _log.error(e);
      return _formatError('save');
    }
  }

  Future<String?> unsave() async {
    final s = submission!;

    if (s.saved) return null;

    try {
      await _redditApi.submissionSave(s.id);
      _submission = s.copyWith(saved: true);
      notifyListeners();
      return 'Unsaved';
    } on Exception catch (e) {
      _log.error(e);
      return _formatError('unsave');
    }
  }

  Future<String?> voteUp() {
    return _updateSubmissionsVote(Vote.up);
  }

  Future<String?> voteDown() {
    return _updateSubmissionsVote(Vote.down);
  }

  Future<String?> _updateSubmissionsVote(Vote vote) async {
    final s = submission!;

    if (s.likes == vote) {
      vote = Vote.none;
    }

    try {
      await _redditApi.submissionVote(s.id, vote);
      _submission = s.copyWith(
        likes: vote,
        score: calcScore(s.score, s.likes, vote),
      );
      notifyListeners();
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return _formatError('vote');
    }
  }

  Future<String?> share() async {
    final s = submission!;

    try {
      await Share.share('${s.title} ${s.shortLink}');
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return _formatError('share');
    }
  }
}

class CommentNotifierQ extends ChangeNotifier {
  CommentNotifierQ(this._redditApi, this.comment) {
    _replies =
        comment.replies.map((v) => CommentNotifierQ(_redditApi, v)).toList();
  }

  final RedditApi _redditApi;
  Comment comment;
  List<CommentNotifierQ> _replies = [];
  static final _log = Logger('SubmissionNotifierQ');

  List<CommentNotifierQ> get replies => _replies;

  Future<String?> save() async {
    if (comment.saved) return null;

    try {
      await _redditApi.commentSave(comment.id);
      comment = comment.copyWith(saved: true);
      notifyListeners();
      return 'Saved';
    } on Exception catch (e) {
      _log.error(e);
      return 'Error: Fail to save';
    }
  }

  Future<String?> unsave() async {
    if (!comment.saved) return null;

    try {
      await _redditApi.commentUnsave(comment.id);
      comment = comment.copyWith(saved: false);
      notifyListeners();
      return 'Unsaved';
    } on Exception catch (e) {
      _log.error(e);
      return 'Error: Fail to unsave';
    }
  }

  Future<String?> upVote() async {
    if (comment.likes == Vote.up) {
      return _updateVote(Vote.none);
    }
    return await _updateVote(Vote.up);
  }

  Future<String?> downVote() async {
    if (comment.likes == Vote.down) {
      return _updateVote(Vote.none);
    }
    return await _updateVote(Vote.down);
  }

  Future<String?> _updateVote(Vote vote) async {
    if (comment.likes == vote) return null;

    try {
      await _redditApi.submissionVote(comment.id, vote);
      comment = comment.copyWith(
        likes: vote,
        score: calcScore(comment.score, comment.likes, vote),
      );
      notifyListeners();
      return null;
    } on Exception catch (e) {
      _log.error(e);
      // _error = e;
      return 'Error: fail to vote';
    }
  }

  Future<String?> share() async {
    try {
      await Share.share('${comment.linkTitle} ${comment.shortLink}');
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return _formatError('share');
    }
  }

  Future<String?> reply(String body) async {
    // try {
    //   // throw Exception('error');
    //   final commentReply = await _redditApi.commentReply(comment.id, body);
    //   // comment = comment.copyWith(replies: [commentReply] + comment.replies);
    //   // _replies.add(CommentNotifierQ(_redditApi, commentReply));
    //   _replies.insert(0, CommentNotifierQ(_redditApi, commentReply));
    //   notifyListeners();
    //   return null;
    // } on Exception catch (e) {
    //   _log.error(e);
    //   return 'Error: Fail to reply';
    // }

    return _try(() async {
      // throw Exception('error');
      final commentReply = await _redditApi.commentReply(comment.id, body);
      // comment = comment.copyWith(replies: [commentReply] + comment.replies);
      // _replies.add(CommentNotifierQ(_redditApi, commentReply));
      _replies.insert(0, CommentNotifierQ(_redditApi, commentReply));
      notifyListeners();
      return null;
    }, 'Error: Fail to reply');
  }

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

  Future<String?> _try(Future<String?> Function() fn, String error) async {
    try {
      return await fn();
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return error;
    }
  }
}

class UserNotifierQ extends ChangeNotifier {
  UserNotifierQ(this._redditApi);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = Logger('UserNotifierQ');

  void _reset() {
    _user = null;
    _submissions = null;
    _comments = null;
    _trophies = null;
  }

  String? _name;

  void _setName(String name) {
    if (_name != name) _reset();
    _name = name;
  }

  User? _user;
  User? get user => _user;
  Future<void> loadUser(String name) {
    return _try(() async {
      _setName(name);
      if (_user != null) return null;
      _user = await _redditApi.user(_name!);
      notifyListeners();
      return null;
    }, 'Error: fail to load user');
  }

  Future<String?> subscribe() {
    return _try(() async {
      if (user!.subreddit.userIsSubscriber) return null;
      await _redditApi.subscribe(user!.subreddit.displayName);
      notifyListeners();
      return null;
    }, 'Error: fail to subscribe');
  }

  Future<String?> unsubscribe() {
    return _try(() async {
      if (!(user!.subreddit.userIsSubscriber)) return null;
      await _redditApi.subscribe(user!.subreddit.displayName);
      notifyListeners();
      return null;
    }, 'Error: fail to unsubscribe');
  }

  List<SubmissionNotifierQ>? _submissions;
  List<SubmissionNotifierQ>? get submissions => _submissions;
  Future<String?> loadSubmissions() {
    return _try(() async {
      if (_submissions != null) return null;
      _submissions =
          (await _redditApi.userSubmissions(_name!, limit: _limit).toList())
              .map((v) => SubmissionNotifierQ(_redditApi, v))
              .toList();
      notifyListeners();
      return null;
    }, 'Error: fail to load user submissions');
  }

  List<CommentNotifierQ>? _comments;
  List<CommentNotifierQ>? get comments => _comments;
  Future<String?> loadComments() {
    return _try(() async {
      if (_comments != null) return null;
      _comments =
          (await _redditApi.userComments(_name!, limit: _limit).toList())
              .map((v) => CommentNotifierQ(_redditApi, v))
              .toList();
      notifyListeners();
      return null;
    }, 'Error: fail to load user comments');
  }

  List<Trophy>? _trophies;
  List<Trophy>? get trophies => _trophies;
  Future<String?> loadTrophies() {
    return _try(() async {
      if (_trophies != null) return null;
      _trophies = await _redditApi.userTrophies(_name!);
      notifyListeners();
      return null;
    }, 'Error: fail to load user comments');
  }

  Future<String?> _try(Future<String?> Function() fn, String error) async {
    try {
      return await fn();
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return error;
    }
  }
}

abstract class CurrentUserNotifierQ extends ChangeNotifier with TryMixin {
  CurrentUserNotifierQ(this._redditApi);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = Logger('CurrentUserNotifierQ');

  User? _user;
  User? get user => _user;

  Future<String?> login(String name, String password) async {
    return _try(() async {
      final user = await _redditApi.currentUser();
      if (user == null) {
        throw Exception('user is null');
      }
      _user = user;
      notifyListeners();
      return null;
    }, 'Error: fail to login');
  }

  Future<String?> logout(String name, String password) async {
    _user = null;
    notifyListeners();
    return null;
  }

  List<SubredditNotifierQ>? _subreddits;
  List<SubredditNotifierQ>? get subreddits => _subreddits;
  Future<String?> loadSubreddits() {
    return _try(() async {
      final user = await _redditApi.currentUser();
      if (user == null) {
        throw Exception('user is null');
      }
      _user = user;
      notifyListeners();
      return null;
    }, 'Error: fail to login');
  }

  Future<String?> loadSavedComment();
  List<CommentNotifierQ>? get savedComment;

  Future<String?> loadSavedSubmissions();
  List<SubmissionNotifierQ>? get savedSubmissions;
}

mixin TryMixin {
  static late final Logger _log;

  Future<String?> _try(Future<String?> Function() fn, String error) async {
    try {
      return await fn();
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return error;
    }
  }
}

String _formatError(String op) {
  return 'Error: fail to $op';
}

int calcScore(int score, Vote oldVote, Vote newVote) {
  if (oldVote == Vote.up) {
    if (newVote == Vote.down) {
      return score - 2;
    } else if (newVote == Vote.none) {
      return score - 1;
    }
  } else if (oldVote == Vote.none) {
    if (newVote == Vote.down) {
      return score - 1;
    } else if (newVote == Vote.up) {
      return score + 1;
    }
  } else if (oldVote == Vote.down) {
    if (newVote == Vote.up) {
      return score + 2;
    } else if (newVote == Vote.none) {
      return score + 1;
    }
  }
  return score;
}

/* class Result {}

class Ok extends Result {
  Ok(this.message);
  String message;
  String toString() => message;
}

class Error extends Result {
  Error(this.message);
  String message;
  String toString() => 'Error: $message';
}

class Reload extends Result {} */
