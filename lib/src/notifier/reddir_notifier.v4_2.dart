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
class SearchNotifierQ extends ChangeNotifier with TryMixin {
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

  Future<void> search(
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
    //   return 'fail to search';
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
      notifyListeners();
      return null;
    }, 'fail to search');
  }
}

class SubredditLoaderNotifierQ extends ChangeNotifier with TryMixin {
  SubredditLoaderNotifierQ(this._redditApi);

  final RedditApi _redditApi;

  static final _log = Logger('SubredditNotifierQ');

  String? _name;
  SubredditNotifierQ? _subreddit;
  SubredditNotifierQ? get subreddit => _subreddit;

  Future<void> loadSubreddit(String name) {
    return _try(() async {
      if (subreddit != null && _name == name) return;
      _name = name;

      // if (_name != name) _subreddit = null;
      // _name = name;
      // if (_subreddit != null) return null;
      _subreddit =
          SubredditNotifierQ(_redditApi, await _redditApi.subreddit(_name!));
      notifyListeners();
      return null;
    }, 'fail to load subreddit');
  }
}

class SubredditNotifierQ extends ChangeNotifier with TryMixin {
  SubredditNotifierQ(this._redditApi, this._subreddit)
      : _name = _subreddit.displayName;

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = Logger('SubredditNotifierQ');

  // set name(name);

  final String _name;
  Subreddit _subreddit;
  Subreddit get subreddit => _subreddit;

  // void _reset() {
  //   _subreddit = null;
  //   _submissions = null;
  //   _about = null;
  //   _menu = null;
  //   _wiki = null;
  // }

  // void _setName(String name) {
  //   if (_name != name) _reset();
  //   _name = name;
  // }

  // Future<void> loadSubreddit(String name) {
  //   return _try(() async {
  //     if (_subreddit != null && _name == name) return null;
  //     _name = name;
  //     _subreddit = await _redditApi.subreddit(_name!);
  //     return null;
  //   }, 'fail to load subreddit');
  // }
  // Future<void> loadSubreddit(String name) {
  //   return _try(() async {
  //     _setName(name);
  //     if (_subreddit != null) return null;
  //     _subreddit = await _redditApi.subreddit(_name!);
  //     notifyListeners();
  //     return null;
  //   }, 'fail to load subreddit');
  // }

  Future<void> subscribe() {
    return _try(() async {
      if (_subreddit.userIsSubscriber) return;
      await _redditApi.subscribe(_name);
      _subreddit = _subreddit.copyWith(userIsSubscriber: true);
      notifyListeners();
      return null;
    }, 'fail to subscribe');
  }

  Future<void> unsubscribe() {
    return _try(() async {
      if (!(_subreddit.userIsSubscriber)) return;
      await _redditApi.subscribe(_name);
      _subreddit = _subreddit.copyWith(userIsSubscriber: false);
      notifyListeners();
      return null;
    }, 'fail to unsubscribe');
  }

  SubType _subType = SubType.best;
  SubType get subType => _subType;

  List<SubmissionNotifierQ>? _submissions;
  List<SubmissionNotifierQ>? get submissions => _submissions;

  Future<void> loadSubmissions(SubType subType) {
    return _try(() async {
      if (_submissions != null && _subType == subType) return null;
      _subType = subType;
      _submissions = await _redditApi
          .subredditSubmissions(_name, limit: _limit, type: _subType)
          .map((v) => SubmissionNotifierQ(_redditApi, v))
          .toList();
      notifyListeners();
      return null;
    }, 'fail to load subreddit submissions');
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

  // TODO
  Future<void> star() => throw UnimplementedError();
  // TODO
  Future<void> unstar() => throw UnimplementedError();
}

class HomeFrontNotifierQ extends ChangeNotifier with TryMixin {
  HomeFrontNotifierQ(this._redditApi);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = Logger('HomeFrontNotifierQ');

  SubType _subType = SubType.best;
  SubType get subType => _subType;

  List<SubmissionNotifierQ>? _submissions;
  List<SubmissionNotifierQ>? get submissions => _submissions;

  Future<void> loadSubmissions(SubType subType) {
    return _try(() async {
      if (_submissions != null && _subType == subType) return null;
      _subType = subType;

      _submissions =
          (await _redditApi.front(limit: _limit, type: _subType).toList())
              .map((v) => SubmissionNotifierQ(_redditApi, v))
              .toList();
      notifyListeners();
      return null;
    }, 'fail to search');
  }
}

class HomePopularNotifierQ extends ChangeNotifier with TryMixin {
  HomePopularNotifierQ(this._redditApi);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = Logger('HomePopularNotifierQ');

  SubType _subType = SubType.best;
  SubType get subType => _subType;

  List<SubmissionNotifierQ>? _submissions;
  List<SubmissionNotifierQ>? get submissions => _submissions;

  Future<void> loadSubmissions(SubType subType) {
    return _try(() async {
      if (_submissions != null && _subType == subType) return null;
      _subType = subType;

      _submissions =
          (await _redditApi.popular(limit: _limit, type: _subType).toList())
              .map((v) => SubmissionNotifierQ(_redditApi, v))
              .toList();
      notifyListeners();
      return null;
    }, 'fail to search');
  }
}

class SubmissionLoaderNotifierQ extends ChangeNotifier with TryMixin {
  SubmissionLoaderNotifierQ(this._redditApi);

  String? _id;

  final RedditApi _redditApi;
  static final _log = Logger('SubmissionNotifierQ');

  SubmissionNotifierQ? _submission;
  SubmissionNotifierQ? get submission => _submission;

  Future<void> loadSubmission(String id) async {
    return _try(() async {
      if (_submission != null && _id == id) return null;
      _id = id;
      _submission =
          SubmissionNotifierQ(_redditApi, await _redditApi.submission(_id!));
      // _setComments(_submission?.comments);
      notifyListeners();
      return null;
    }, 'fail to load submission');
  }
}

class SubmissionNotifierQ extends ChangeNotifier with TryMixin {
  SubmissionNotifierQ(this._redditApi, this._submission) {
    _setComments(_submission.comments);
  }

  // final String _id;

  final RedditApi _redditApi;
  static final _log = Logger('SubmissionNotifierQ');

  List<CommentNotifierQ>? _comments;
  List<CommentNotifierQ>? get comments => _comments;

  Submission _submission;
  Submission get submission => _submission;

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

  // Future<void> loadSubmission(String id) async {
  //   if (_id == id) return null;
  //   _id = id;
  //   print('loadSubmission');
  //   return reloadSubmission();
  // }

  // Future<void> reloadSubmission() async {
  //   try {
  //     _submission = await _redditApi.submission(_id!);
  //     _setComments(_submission?.comments);
  //     notifyListeners();
  //     return null;
  //   } on Exception catch (e, st) {
  //     _log.error('', e, st);
  //     return _formatError('load');
  //   }
  // }

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

  Future<void> reply(String body) async {
    return _try(() async {
      final commentReply =
          await _redditApi.submissionReply(submission.id, body);
      // _comments!.add(CommentNotifierQ(_redditApi, commentReply));
      if (_comments == null) {
        _comments = [];
      }
      _comments!.insert(0, CommentNotifierQ(_redditApi, commentReply));
      notifyListeners();
      return null;
    }, 'fail to reply');
  }

  // TODO: save unsave
  Future<void> save() async {
    return _try(() async {
      if (submission.saved) return null;

      await _redditApi.submissionSave(submission.id);
      _submission = submission.copyWith(saved: true);
      notifyListeners();
    }, 'fail to save');
  }

  Future<void> unsave() {
    return _try(() async {
      if (submission.saved) return null;

      await _redditApi.submissionSave(submission.id);
      _submission = submission.copyWith(saved: true);
      notifyListeners();
    }, 'fail to unsave');
  }

  Future<void> voteUp() {
    return _updateSubmissionsVote(Vote.up);
  }

  Future<void> voteDown() {
    return _updateSubmissionsVote(Vote.down);
  }

  Future<void> _updateSubmissionsVote(Vote vote) async {
    return _try(() async {
      if (submission.likes == vote) {
        vote = Vote.none;
      }

      await _redditApi.submissionVote(submission.id, vote);
      _submission = submission.copyWith(
        likes: vote,
        score: calcScore(submission.score, submission.likes, vote),
      );
      notifyListeners();
      return null;
    }, 'fail to vote');
  }

  Future<void> share() async {
    return _try(() async {
      await Share.share('${submission.title} ${submission.shortLink}');
    }, 'fail to share');
  }
}

class CommentNotifierQ with TryMixin, CollapseMixin, ChangeNotifier {
  CommentNotifierQ(this._redditApi, this.comment) {
    _replies =
        comment.replies.map((v) => CommentNotifierQ(_redditApi, v)).toList();
  }

  final RedditApi _redditApi;
  Comment comment;
  List<CommentNotifierQ> _replies = [];
  static final _log = Logger('SubmissionNotifierQ');

  List<CommentNotifierQ> get replies => _replies;

  Future<void> save() async {
    return _try(() async {
      if (comment.saved) return null;

      await _redditApi.commentSave(comment.id);
      comment = comment.copyWith(saved: true);
      notifyListeners();
    }, 'fail to save');
  }

  Future<void> unsave() async {
    return _try(() async {
      if (!comment.saved) return null;

      await _redditApi.commentUnsave(comment.id);
      comment = comment.copyWith(saved: false);
      notifyListeners();
    }, 'fail to unsave');
  }

  Future<void> upVote() async {
    if (comment.likes == Vote.up) {
      return _updateVote(Vote.none);
    }
    return await _updateVote(Vote.up);
  }

  Future<void> downVote() async {
    if (comment.likes == Vote.down) {
      return _updateVote(Vote.none);
    }
    return await _updateVote(Vote.down);
  }

  Future<void> _updateVote(Vote vote) async {
    return _try(() async {
      if (comment.likes == vote) return null;

      await _redditApi.submissionVote(comment.id, vote);
      comment = comment.copyWith(
        likes: vote,
        score: calcScore(comment.score, comment.likes, vote),
      );
      notifyListeners();
    }, 'fail to vote');
  }

  Future<void> share() async {
    return _try(() async {
      await Share.share('${comment.linkTitle} ${comment.shortLink}');
    }, 'fail to share');
  }

  Future<void> reply(String body) async {
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
    //   return 'fail to reply';
    // }

    return _try(() async {
      // throw Exception('error');
      final commentReply = await _redditApi.commentReply(comment.id, body);
      // comment = comment.copyWith(replies: [commentReply] + comment.replies);
      // _replies.add(CommentNotifierQ(_redditApi, commentReply));
      _replies.insert(0, CommentNotifierQ(_redditApi, commentReply));
      notifyListeners();
    }, 'fail to reply');
  }
}

class UserLoaderNotifierQ extends ChangeNotifier with TryMixin {
  UserLoaderNotifierQ(this._redditApi);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = Logger('UserLoaderNotifierQ');

  // void _reset() {
  //   _user = null;
  // }

  String? _name;

  // void _setName(String name) {
  //   if (_name != name) _reset();
  //   _name = name;
  // }

  UserNotifierQ? _user;
  UserNotifierQ? get user => _user;

  Future<void> loadUser(String name) {
    return _try(() async {
      if (_user != null && _name == name) return;
      _name = name;
      // _setName(name);
      // if (_user != null) return null;
      _user = UserNotifierQ(_redditApi, await _redditApi.user(_name!));
      notifyListeners();
    }, 'fail to load user');
  }
}

class UserNotifierQ extends ChangeNotifier with TryMixin {
  UserNotifierQ(this._redditApi, this._user) : _name = _user.name;

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = Logger('UserNotifierQ');

  // void _reset() {
  //   _user = null;
  //   _submissions = null;
  //   _comments = null;
  //   _trophies = null;
  // }

  final String _name;

  // void _setName(String name) {
  //   if (_name != name) _reset();
  //   _name = name;
  // }

  User _user;
  User get user => _user;
  // Future<void> loadUser(String name) {
  //   return _try(() async {
  //     _setName(name);
  //     if (_user != null) return null;
  //     _user = await _redditApi.user(_name!);
  //     notifyListeners();
  //     return null;
  //   }, 'fail to load user');
  // }

  Future<void> subscribe() {
    return _try(() async {
      if (user.subreddit.userIsSubscriber) return null;
      await _redditApi.subscribe(user.subreddit.displayName);
      notifyListeners();
    }, 'fail to subscribe');
  }

  Future<void> unsubscribe() {
    return _try(() async {
      if (!(user.subreddit.userIsSubscriber)) return null;
      await _redditApi.subscribe(user.subreddit.displayName);
      notifyListeners();
    }, 'fail to unsubscribe');
  }

  List<SubmissionNotifierQ>? _submissions;
  List<SubmissionNotifierQ>? get submissions => _submissions;
  Future<void> loadSubmissions() {
    return _try(() async {
      if (_submissions != null) return null;
      _submissions =
          (await _redditApi.userSubmissions(_name, limit: _limit).toList())
              .map((v) => SubmissionNotifierQ(_redditApi, v))
              .toList();
      notifyListeners();
    }, 'fail to load user submissions');
  }

  List<CommentNotifierQ>? _comments;
  List<CommentNotifierQ>? get comments => _comments;
  Future<void> loadComments() {
    return _try(() async {
      if (_comments != null) return null;
      _comments = (await _redditApi.userComments(_name, limit: _limit).toList())
          .map((v) => CommentNotifierQ(_redditApi, v))
          .toList();
      notifyListeners();
    }, 'fail to load user comments');
  }

  List<Trophy>? _trophies;
  List<Trophy>? get trophies => _trophies;
  Future<void> loadTrophies() {
    return _try(() async {
      if (_trophies != null) return null;
      _trophies = await _redditApi.userTrophies(_name);
      notifyListeners();
    }, 'fail to load user comments');
  }
}

class UserAuth extends ChangeNotifier with TryMixin {
  UserAuth(this._redditApi);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = Logger('UserAuth');

  CurrentUserNotifierQ? _user;
  CurrentUserNotifierQ? get user => _user;

  Future<void> login(String name, String password) async {
    return _try(() async {
      final user = await _redditApi.currentUser();
      if (user == null) {
        throw Exception('user is null');
      }
      _user = CurrentUserNotifierQ(_redditApi, user);
      notifyListeners();
    }, 'fail to login');
  }

  Future<void> logout(String name, String password) async {
    _user = null;
    notifyListeners();
    return null;
  }
}

class CurrentUserNotifierQ extends ChangeNotifier with TryMixin {
  CurrentUserNotifierQ(this._redditApi, this._user);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = Logger('CurrentUserNotifierQ');

  User _user;
  User get user => _user;

  // Future<void> login(String name, String password) async {
  //   return _try(() async {
  //     final user = await _redditApi.currentUser();
  //     if (user == null) {
  //       throw Exception('user is null');
  //     }
  //     _user = user;
  //     notifyListeners();
  //     return null;
  //   }, 'fail to login');
  // }

  // Future<void> logout(String name, String password) async {
  //   _user = null;
  //   notifyListeners();
  //   return null;
  // }

  List<SubredditNotifierQ>? _subreddits;
  List<SubredditNotifierQ>? get subreddits => _subreddits;

  Future<void> loadSubreddits() {
    return _try(() async {
      _subreddits = await _redditApi
          .userSubreddits(limit: _limit)
          .map((v) => SubredditNotifierQ(_redditApi, v))
          .toList();
      notifyListeners();
    }, 'fail to load subreddits');
  }

  List<CommentNotifierQ>? _savedComments;
  List<CommentNotifierQ>? get savedComments => _savedComments;

  Future<void> loadSavedComments() {
    {
      return _try(() async {
        _savedComments = await _redditApi
            .userComments(_user.name, limit: _limit)
            .map((v) => CommentNotifierQ(_redditApi, v))
            .toList();
        notifyListeners();
      }, 'fail to login');
    }
  }

  List<SubmissionNotifierQ>? _savedSubmissions;
  List<SubmissionNotifierQ>? get savedSubmissions => _savedSubmissions;

  Future<void> loadSavedSubmissions() {
    {
      return _try(() async {
        _savedSubmissions = await _redditApi
            .userSubmissions(_user.name, limit: _limit)
            .map((v) => SubmissionNotifierQ(_redditApi, v))
            .toList();
        notifyListeners();
      }, 'fail to load saved submissions');
    }
  }
}

class UIException implements Exception {
  UIException(this._message);
  String _message;
  String toString() => 'Error: $_message';
}

mixin TryMixin {
  static late final Logger _log;

  // Future<void> _try(Future<void> Function() fn, String error) async {
  //   try {
  //     return await fn();
  //   } on Exception catch (e, st) {
  //     _log.error('', e, st);
  //     return error;
  //   }
  // }

  Future<void> _try(Future<void> Function() fn, String error) async {
    try {
      return await fn();
    } on Exception catch (e, st) {
      _log.error('', e, st);
      throw Exception(error);
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

  // must override
  void notifyListeners() {
    throw UnimplementedError();
  }
}

// String _formatError(String op) {
//   return 'fail to $op';
// }

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
  Future<Result?> undo();
}

class Error extends Result {
  Error(this.message);
  String message;
  String toString() => '$message';
  Future<Result?> retry();
}

class Reload extends Result {} */
