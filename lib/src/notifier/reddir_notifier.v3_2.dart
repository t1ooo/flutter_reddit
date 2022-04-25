import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_reddit_prototype/src/reddit_api/submission_type.dart';
import 'package:share_plus/share_plus.dart';

import '../logging/logging.dart';
import '../reddit_api/comment.dart';
import '../reddit_api/reddir_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/subreddit.dart';
import '../reddit_api/trophy.dart';
import '../reddit_api/user.dart';
import '../reddit_api/vote.dart';

// TODO: comments to list

typedef ListView<T> = UnmodifiableListView<T>;

ListView<T>? ListViewN<T>(List<T>? list) {
  if (list == null) {
    return null;
  }
  return ListView(list);
}

class SearchNotifierX with SubmissionsMixinX, ChangeNotifier {
  SearchNotifierX(this._redditApi);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = Logger('SearchNotifierX');

  String _subredditName = '';
  String get subredditName => _subredditName;

  String _query = '';
  String get query => query;

  Sort _sort = Sort.relevance;
  Sort get sort => _sort;

  List<Sort> get sorts => Sort.values;

  List<Submission>? _submission;
  ListView<Submission>? get submission => ListViewN(_submission);

  Future<String?> search(
    String query,
    Sort sort, [
    String subredditName = 'all',
  ]) async {
    _query = query;
    _sort = sort;
    _subredditName = subredditName;
    _submission = null;
    notifyListeners();

    try {
      _submission =
          await _redditApi.search(_query, limit: _limit, sort: _sort).toList();
      notifyListeners();
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return 'Error: fail to search';
    }
  }
}

class SubredditNotifierX with SubmissionsMixinX, ChangeNotifier {
  SubredditNotifierX(this._redditApi);

  final RedditApi _redditApi;
  static final _log = Logger('SearchNotifierX');
  int _limit = 10;

  String _name = '';
  set name(String name) {
    if (_name == name) {
      return;
    }
    _name = name;
    notifyListeners();
  }

  Subreddit? _subreddit;
  Subreddit? get subreddit => _subreddit;

  Future<String?> loadSubreddit() async {
    try {
      _subreddit = await _redditApi.subreddit(_name);
      notifyListeners();
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return 'Error: fail to search';
    }
  }

  SubType _subType = SubType.best;
  SubType get subType => _subType;
  List<SubType> get subTypes => SubType.values;

  List<Submission>? _submission;
  List<Submission>? get submission => _submission;

  Future<String?> loadSubmissions(SubType subType) async {
    try {
      _submission = await _redditApi
          .subredditSubmissions(_name, limit: _limit, type: _subType)
          .toList();
      notifyListeners();
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return 'Error: fail to search';
    }
  }

  Future<String?> subscribe() async {
    final subreddit = _subreddit!;

    if (subreddit.userIsSubscriber) return null;

    try {
      await _redditApi.subscribe(_name);
      _subreddit = subreddit.copyWith(userIsSubscriber: true);
      notifyListeners();
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return _formatError('subscribe');
    }
  }

  Future<String?> unsubscribe() async {
    final subreddit = _subreddit!;

    if (!subreddit.userIsSubscriber) return null;

    try {
      await _redditApi.subscribe(_name);
      _subreddit = subreddit.copyWith(userIsSubscriber: false);
      notifyListeners();
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return _formatError('unsubscribe');
    }
  }

  Future<String?> star() async {
    // TODO
    //throw UnimplementedError();
  }

  Future<String?> unstar() async {
    // TODO
    throw UnimplementedError();
  }

  // Future<String?> loadAbout();
  // get about;

  // Future<String?> loadMenu();
  // get menu;
}

// abstract class HomeFrontNotifierX with SubmissionsMixinX, ChangeNotifier {
//   get subType;
//   get subTypes;

//   Future<String?> loadSubmissions(subType);
//   List<Submission>? get submission;
// }

// abstract class HomePopularNotifierX with SubmissionsMixinX, ChangeNotifier {
//   get subType;
//   get subTypes;
//   Future<String?> loadSubmissions(subType);
//   List<Submission>? get submission;
// }

class HomeNotifierX with SubmissionsMixinX, ChangeNotifier {
  HomeNotifierX(this._redditApi);

  final RedditApi _redditApi;
  static final _log = Logger('HomeNotifierX');
  int _limit = 10;

  List<SubType> get subTypes => SubType.values;

  SubType _frontSubType = SubType.best;
  SubType get frontSubType => _frontSubType;

  List<Submission>? _frontSubmission;
  List<Submission>? get frontSubmission => frontSubmission;

  Future<String?> loadFrontSubmissions(SubType subType) async {
    try {
      _frontSubType = subType;
      _frontSubmission =
          await _redditApi.front(limit: _limit, type: _frontSubType).toList();
      notifyListeners();
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return _formatError('load');
    }
  }

  SubType _popularSubType = SubType.best;
  SubType get popularSubType => _popularSubType;

  List<Submission>? _popularSubmission;
  List<Submission>? get popularSubmission => popularSubmission;

  Future<String?> loadPopularSubmissions(SubType subType) async {
    try {
      _popularSubType = subType;
      _frontSubmission = await _redditApi
          .popular(limit: _limit, type: _popularSubType)
          .toList();
      notifyListeners();
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return _formatError('load');
    }
  }
}

abstract class SubmissionNotifierX with CommentsMixin, SubmissionsMixinX {
  SubmissionNotifierX(this._redditApi);

  final RedditApi _redditApi;
  static final _log = Logger('SubmissionNotifierX');

  Submission? _submission;
  Submission? get submission => _submission;

  Future<String?> loadSubmission(id) async {
    try {
      _submission = await _redditApi.submission(id);
      notifyListeners();
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return _formatError('load');
    }
  }
}

abstract class UserNotifierX with CommentsMixin, SubmissionsMixinX {
  User? _user;
  User? get user => _user;
  Future<void> loadUser(name);

  Future<String?> subscribe();
  Future<String?> unsubscribe();

  // List<Submission>? _submissions;
  List<Submission>? get submissions => _submissions.values.toList();

  // Future<String?> loadSubmissions() {
  //   try {
  //     _submission = await _redditApi.userSubmissions(_name);
  //     notifyListeners();
  //     return null;
  //   } on Exception catch (e, st) {
  //     _log.error('', e, st);
  //     return _formatError('load');
  //   }
  // }

  // List<Comment>? _comments;
  List<Comment>? get comments => _comments.values.toList();

  Future<String?> loadComments();

  List<Trophy>? _trophies;
  List<Trophy>? get trophies => _trophies;

  Future<String?> loadTrophies();
}

abstract class CurrentUserNotifierX with CommentsMixin, SubmissionsMixinX {
  Future<String?> login();
  Future<String?> logout();

  Future<String?> loadSubreddits();
  List<Subreddit>? get subreddits;

  Future<String?> loadSavedComment();
  List<Comment>? get savedComment;

  Future<String?> loadSavedSubmissions();
  List<Submission>? get savedSubmissions;
}

mixin SubmissionsMixinX {
  late final RedditApi _redditApi;
  static late final Logger _log;
  late LinkedHashMap<String, Submission> _submissions;

  Future<String?> saveSubmissions(String submissionId) async {
    final submission = _submissions[submissionId];
    if (submission == null) {
      _log.error('submission not found: $submissionId');
      return null;
    }

    if (submission.saved) return null;

    try {
      await _redditApi.submissionSave(submission.id);
      _submissions[submissionId] = submission.copyWith(saved: true);
      notifyListeners();
      return 'Saved';
    } on Exception catch (e) {
      _log.error(e);
      return _formatError('save');
    }
  }

  Future<String?> unsaveSubmissions(String submissionId) async {
    final submission = _submissions[submissionId];
    if (submission == null) {
      _log.error('submission not found: $submissionId');
      return null;
    }

    if (submission.saved) return null;

    try {
      await _redditApi.submissionSave(submission.id);
      _submissions[submissionId] = submission.copyWith(saved: true);
      notifyListeners();
      return 'Unsaved';
    } on Exception catch (e) {
      _log.error(e);
      return _formatError('unsave');
    }
  }

  Future<String?> voteUpSubmissions(String submissionId) {
    return _updateSubmissionsVote(submissionId, Vote.up);
  }

  Future<String?> voteDownSubmissions(String submissionId) {
    return _updateSubmissionsVote(submissionId, Vote.down);
  }

  Future<String?> _updateSubmissionsVote(String submissionId, Vote vote) async {
    final submission = _submissions[submissionId];
    if (submission == null) {
      _log.error('submission not found: $submissionId');
      return null;
    }

    if (submission.likes == vote) {
      vote = Vote.none;
    }

    try {
      await _redditApi.submissionVote(submission.id, vote);
      _submissions[submissionId] = submission.copyWith(
        likes: vote,
        score: calcScore(submission.score, submission.likes, vote),
      );
      notifyListeners();
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return _formatError('vote');
    }
  }

  Future<String?> shareSubmissions(String submissionId) async {
    final submission = _submissions[submissionId];
    if (submission == null) {
      _log.error('submission not found: $submissionId');
      return null;
    }

    try {
      await Share.share('${submission.title} ${submission.shortLink}');
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return _formatError('share');
    }
  }

  // Future<String?> replySubmissions(String submissionId);

  // String _formatError(String op) {
  //   return 'Error: fail to $op submission';
  // }

  void notifyListeners() {
    throw UnimplementedError();
  }
}

LinkedHashMap<String, Comment> commentMapFromList(List<Comment> comments) {
  final  map = LinkedHashMap<String, Comment>();
  for(final comment in comments) {
    map[comment.id] = comment;
  }
  return map;
}

// TODO: flatten comments
// TODO: replace reply comment -> comments_id
mixin CommentsMixin {
  late final RedditApi _redditApi;
  static late final Logger _log;
  late LinkedHashMap<String, Comment> _comments;

  expand(); // TODO

  Future<String?> saveComment(String commentId) async {
    final comment = _comments[commentId];
    if (comment == null) {
      _log.error('comment not found: $commentId');
      return null;
    }

    if (comment.saved) return null;

    try {
      await _redditApi.commentSave(commentId);
      _comments[commentId] = comment.copyWith(saved: true);
      notifyListeners();
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return _formatError('save');
    }
  }

  Future<String?> unsaveComment(String commentId) async {
    final comment = _comments[commentId];
    if (comment == null) {
      _log.error('comment not found: $commentId');
      return null;
    }

    if (!comment.saved) return null;

    try {
      await _redditApi.commentUnsave(commentId);
      _comments[commentId] = comment.copyWith(saved: false);
      notifyListeners();
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return _formatError('unsave');
    }
  }

  Future<String?> upvoteComment(String commentId) async {
    return await _updateCommentVote(commentId, Vote.up);
  }

  Future<String?> downvoteComment(String commentId) async {
    return await _updateCommentVote(commentId, Vote.down);
  }

  Future<String?> _updateCommentVote(String commentId, Vote vote) async {
    final comment = _comments[commentId];
    if (comment == null) {
      _log.error('comment not found: $commentId');
      return null;
    }

    if (comment.likes == vote) {
      vote = Vote.none;
    }

    try {
      await _redditApi.commentVote(comment.id, vote);
      _comments[commentId] = comment.copyWith(
        likes: vote,
        score: calcScore(comment.score, comment.likes, vote),
      );
      notifyListeners();
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return _formatError('vote');
    }
  }

  Future<String?> shareComment(String commentId) async {
    final comment = _comments[commentId];
    if (comment == null) {
      _log.error('comment not found: $commentId');
      return null;
    }

    try {
      await Share.share('${comment.linkTitle} ${comment.shortLink}');
      return null;
    } on Exception catch (e, st) {
      _log.error('', e, st);
      return _formatError('share');
    }
  }

  // TODO
  Future<String?> replyToComment(String commentId, String body) async {
    final comment = _comments[commentId];
    if (comment == null) {
      _log.error('comment not found: $commentId');
      return null;
    }

    try {
      final commentReply = await _redditApi.commentReply(comment.id, body);
      _comments[commentId] =
          comment.copyWith(replies: [commentReply] + comment.replies);
      notifyListeners();
      return null;
    } on Exception catch (e) {
      _log.error(e);
      return _formatError('reply');
    }
  }

  // TODO: pass comment to end
  Future<String?> replyToSubmission(String submissionId, String body) async {
    try {
      final commentReply = await _redditApi.submissionReply(submissionId, body);
      _comments[commentReply.id] = commentReply;
      notifyListeners();
      return null;
    } on Exception catch (e) {
      _log.error(e);
      return _formatError('reply');
    }
  }

  // String _formatError(String op) {
  //   return 'Error: fail to $op comment';
  // }

  void notifyListeners() {
    throw UnimplementedError();
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

// class OrderedMap<K, V> {
//   OrderedMap(this.keys, this.values) : assert(keys.length == values.length);

//   List<K> keys;
//   List<V> values;
// }
