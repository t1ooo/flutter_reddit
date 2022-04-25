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
  ]) async {
    if (_query == query && _sort == sort && _subredditName == subredditName)
      return null;

    _query = query;
    _sort = sort;
    _subredditName = subredditName;
    _submissions = null;
    notifyListeners();

    try {
      _submissions =
          (await _redditApi.search(_query, limit: _limit, sort: _sort).toList())
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

abstract class SubredditNotifierQ extends ChangeNotifier {
  set name(name);
  Future<String?> subscribe();
  Future<String?> unsubscribe();

  set subType(subType);
  get subType;
  Future<String?> loadSubmissions();
  List<SubmissionNotifierQ>? get submission;

  Future<String?> loadAbout();
  get about;

  Future<String?> loadMenu();
  get menu;

  Future<String?> star();
  Future<String?> unstar();
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
    if ((_id ?? '') == id) return null;
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
    if ((_id ?? '') == id) return Reload();
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
    try {
      // throw Exception('error');
      final commentReply = await _redditApi.commentReply(comment.id, body);
      // comment = comment.copyWith(replies: [commentReply] + comment.replies);
      // _replies.add(CommentNotifierQ(_redditApi, commentReply));
      _replies.insert(0, CommentNotifierQ(_redditApi, commentReply));
      notifyListeners();
      return null;
    } on Exception catch (e) {
      _log.error(e);
      return 'Error: Fail to reply';
    }
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
}

abstract class UserNotifierQ extends ChangeNotifier {
  set name(_);

  Future<void> loadUser();
  User get user;

  Future<String?> subscribe();
  Future<String?> unsubscribe();

  Future<String?> loadSubmissions();
  List<SubmissionNotifierQ>? get submissions;

  Future<String?> loadComments();
  List<CommentNotifierQ>? get comments;

  Future<String?> loadTrophies();
  List<Trophy>? get trophies;
}

abstract class CurrentUserNotifierQ extends ChangeNotifier {
  Future<String?> login();
  Future<String?> logout();

  Future<String?> loadSubreddits();
  List<SubredditNotifierQ>? get subreddits;

  Future<String?> loadSavedComment();
  List<CommentNotifierQ>? get savedComment;

  Future<String?> loadSavedSubmissions();
  List<SubmissionNotifierQ>? get savedSubmissions;
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

class Result {}

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

class Reload extends Result {}
