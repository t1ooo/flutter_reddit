import 'package:draw/draw.dart' as draw;
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:share_plus/share_plus.dart';

import '../logging/logging.dart';
import '../reddit_api/trophy.dart';
import '../reddit_api/user.dart';
import '../reddit_api/comment.dart';
import '../reddit_api/reddir_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import '../reddit_api/subreddit.dart';
import '../reddit_api/vote.dart';
import '../util/result.dart';

// class RedditNotifier extends ChangeNotifier {
//   RedditNotifier(this.redditApi);

//   final RedditApi redditApi;
//   List<Submission>? _frontBest;
//   List<Submission>? _popular;
//   List<Subreddit>? _userSubreddits;

//   List<Submission>? get popular => _popular;
//   List<Submission>? get front => _frontBest;
//   List<Subreddit>? get userSubreddits => _userSubreddits;

//   Future<void> loadFrontBest({int limit = 10}) async {
//     _frontBest = await redditApi.front(limit: limit);
//     notifyListeners();
//   }

//   Future<void> loadPopular({int limit = 10}) async {
//     _popular = await redditApi.popular(limit: limit);
//     notifyListeners();
//   }

//   Future<void> loadUserSubreddits({int limit = 10}) async {
//     _userSubreddits = await redditApi.userSubreddits(limit: limit)
//       ..sort((a, b) => a.displayName.compareTo(b.displayName));
//     notifyListeners();
//   }
// }

/* mixin Result<T> {
  T? _result;

  T? get result {
    final tmp = _result;
    _result = null;
    return tmp;
  }
} */

// mixin Error {
//   Object? _error;

//   Object? get error {
//     final tmp = _error;
//     _error = null;
//     return tmp;
//   }
// }

mixin Error<T> {
  T? _error;

  T? get error {
    final tmp = _error;
    _error = null;
    return tmp;
  }
}

mixin Loading {
  bool _isLoading = false;

  bool get isLoading => _isLoading;
}

class RedditNotifier extends ChangeNotifier {
  RedditNotifier(this.redditApi);

  final RedditApi redditApi;

  static final _log = Logger('RedditNotifier');

/*   Stream<Submission> front({int limit = 10, SubType type = SubType.best}) {
    return redditApi.front(limit: limit, type: type);
  }

  Stream<Submission> popular({int limit = 10, SubType type = SubType.best}) {
    return redditApi.popular(limit: limit, type: type);
  }

  Stream<Subreddit> userSubreddits({int limit = 10}) {
    return redditApi.userSubreddits(limit: limit);
    // ..sort((a, b) => a.displayName.compareTo(b.displayName));
  } */

  Stream<Submission> subredditSubmissions(
    String name, {
    int limit = 10,
    SubType type = SubType.best,
  }) {
    return redditApi.subredditSubmissions(name, limit: limit, type: type);
  }

  Future<User> user(String name) {
    return redditApi.user(name);
  }

  Stream<Comment> userComments(String name, {int limit = 10}) {
    return redditApi.userComments(name, limit: limit);
  }

  Stream<Submission> userSubmissions(String name, {int limit = 10}) {
    return redditApi.userSubmissions(name, limit: limit);
  }

  Future<List<Trophy>> userTrophies(String name) {
    return redditApi.userTrophies(name);
  }

  Future<Submission> submission(String id) async {
    return redditApi.submission(id);
  }

  Future<Subreddit> subreddit(String name) async {
    return redditApi.subreddit(name);
  }

  Future<void> submissionVote(String id, Vote vote) async {
    return redditApi.submissionVote(id, vote);
  }

  Future<void> submissionSave(String id) async {
    return redditApi.submissionSave(id);
  }

  Future<void> submissionUnsave(String id) async {
    return redditApi.submissionUnsave(id);
  }

  Future<void> commentSave(String id) async {
    return redditApi.commentSave(id);
  }

  Future<void> commentUnsave(String id) async {
    return redditApi.commentUnsave(id);
  }

  // Future<User?> currentUser() async {
  //   return redditApi.currentUser();
  // }

  Stream<Submission> currentUserSavedSubmissions({int limit = 10}) {
    return redditApi.currentUserSavedSubmissions(limit: limit);
  }

  Stream<Comment> currentUserSavedComments({int limit = 10}) {
    return redditApi.currentUserSavedComments(limit: limit);
  }

  Future<String> subredditIcon(String name) {
    return redditApi.subredditIcon(name);
  }

  // Future<String> userIcon(String name) {
  //   return redditApi.userIcon(name);
  // }

  Stream<Submission> search(String query,
      {int limit = 10, Sort sort = Sort.relevance}) {
    return redditApi.search(query, limit: limit, sort: sort);
  }

  /* Future<void> submissionReply(String id, String body) async {
    await redditApi.submissionReply(id, body);
    notifyListeners();
  }

  Future<void> commentReply(String id, String body) async {
    await redditApi.commentReply(id, body);
    notifyListeners();
  } */
}

abstract class SubmissionsNotifier extends ChangeNotifier {
  // SubmissionNotifier(this.redditApi);

  // final RedditApi redditApi;
  static final _log = Logger('SubmissionNotifier');
  final List<Submission> _submissions = [];

  SubType _type = SubType.best;

  SubType get type => _type;

  set type(SubType type) {
    _type = type;
    notifyListeners();
  }

  Stream<Submission> submissions({int limit = 10}) {
    // return redditApi.front(limit: limit, type: _type);
    if (_submissions.isNotEmpty) {
      print('cached');
      return Stream.fromIterable(_submissions);
    }
    return _load(limit, _type)
        // ..forEach((v) => _submissions.add(v));
        .map((v) {
      _submissions.add(v);
      return v;
    });
  }

  void reload() {
    _submissions.clear();
    notifyListeners();
  }

  Stream<Submission> _load(int limit, SubType type);
}

class FrontSubmissionsNotifier extends SubmissionsNotifier {
  FrontSubmissionsNotifier(this.redditApi);

  final RedditApi redditApi;

  @override
  Stream<Submission> _load(int limit, SubType type) {
    return redditApi.front(limit: limit, type: type);
  }
}

class PopularSubmissionsNotifier extends SubmissionsNotifier {
  PopularSubmissionsNotifier(this.redditApi);

  final RedditApi redditApi;

  @override
  Stream<Submission> _load(int limit, SubType type) {
    return redditApi.popular(limit: limit, type: type);
  }
}

// class FrontSubmission extends ChangeNotifier {
//   FrontSubmission(this.redditApi);

//   final RedditApi redditApi;
//   static final _log = Logger('FrontSubmission');
//   final List<Submission> _submissions = [];

//   SubType _type = SubType.best;

//   SubType get type => _type;

//   set type(SubType type) {
//     _type = type;
//     notifyListeners();
//   }

//   Stream<Submission> front({int limit = 10}) {
//     // return redditApi.front(limit: limit, type: _type);
//     if (_submissions.isNotEmpty) {
//       print('cached');
//       return Stream.fromIterable(_submissions);
//     }
//     return redditApi.front(limit: limit, type: _type)
//         // ..forEach((v) => _submissions.add(v));
//         .map((v) {
//       _submissions.add(v);
//       return v;
//     });
//   }

//   void reload() {
//     _submissions.clear();
//     notifyListeners();
//   }
// }

// class PopularSubmission extends ChangeNotifier {
//   PopularSubmission(this.redditApi);

//   final RedditApi redditApi;
//   static final _log = Logger('PopularSubmission');
//   final List<Submission> _submissions = [];

//   SubType _type = SubType.best;

//   SubType get type => _type;

//   set type(SubType type) {
//     _type = type;
//     notifyListeners();
//   }

//   Stream<Submission> popular({int limit = 10}) {
//     // return redditApi.front(limit: limit, type: _type);
//     if (_submissions.isNotEmpty) {
//       return Stream.fromIterable(_submissions);
//     }
//     return redditApi.popular(limit: limit, type: _type)
//         // ..forEach((v) => _submissions.add(v));
//         .map((v) {
//       _submissions.add(v);
//       return v;
//     });
//   }

//   void reload() {
//     _submissions.clear();
//     notifyListeners();
//   }
// }

class CurrentUserNotifier extends ChangeNotifier /* with Error<Object> */ {
  CurrentUserNotifier(this.redditApi);

  final RedditApi redditApi;
  static final _log = Logger('CurrentUserNotifier');

  User? _user;
  User? get user => _user;

  Stream<Submission> front({int limit = 10, SubType type = SubType.best}) {
    return redditApi.front(limit: limit, type: type);
  }

  Stream<Submission> popular({int limit = 10, SubType type = SubType.best}) {
    return redditApi.popular(limit: limit, type: type);
  }

  Stream<Subreddit> subreddits({int limit = 10}) {
    return redditApi.userSubreddits(limit: limit);
    // ..sort((a, b) => a.displayName.compareTo(b.displayName));
  }

  // Future<void> login(String name, String password) async {
  //   // _user = await redditApi.currentUser();
  //   try {
  //     final user = await redditApi.currentUser();
  //     if (user == null) {
  //       throw Exception('fail to login');
  //     }
  //     _user = user;
  //   } catch (e) {
  //     _log.error(e);
  //     _error = e;
  //   }
  //   notifyListeners();
  // }

  Future<String?> login(String name, String password) async {
    try {
      final user = await redditApi.currentUser();
      if (user == null) {
        throw Exception('fail to login');
      }
      _user = user;
      notifyListeners();
      return null;
    } catch (e) {
      _log.error(e);
      return 'Error: Fail to login';
    }
  }

  Future<void> logout(String name, String password) async {
    _user = null;
    notifyListeners();
  }
}

class SubTypeNotifier extends ChangeNotifier {
  SubTypeNotifier([SubType type = SubType.best]) : _type = type;

  SubType _type = SubType.best;

  SubType get type => _type;

  set type(SubType type) {
    if (_type == type) return;

    _type = type;
    notifyListeners();
  }
}

class SortNotifier extends ChangeNotifier {
  SortNotifier([Sort type = Sort.relevance]) : _type = type;

  Sort _type = Sort.relevance;

  Sort get type => _type;

  set type(Sort type) {
    if (_type == type) return;

    _type = type;
    notifyListeners();
  }
}

class CollapseNotifier extends ChangeNotifier {
  CollapseNotifier([bool collapsed = false]) : _collapsed = collapsed;

  bool _collapsed;

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

// class FilterNotifier<T> extends ChangeNotifier {
//   FilterNotifier(T type) : _type = type;

//   T _type;

//   T get type => _type;

//   set type(T type) {
//     if (_type == type) return;

//     _type = type;
//     notifyListeners();
//   }
// }

class SubscriptionNotifier extends ChangeNotifier /* with Error<Object> */ {
  SubscriptionNotifier(this.redditApi, bool isSubscriber)
      : _isSubscriber = isSubscriber;

  final RedditApi redditApi;
  static final _log = Logger('SubscriptionNotifier');

  // bool _isLoading = false;
  // bool get isLoading => _isLoading;

  // Object? _error;
  // Object? get error {
  //   final tmp = _error;
  //   _error = null;
  //   return tmp;
  // }

  bool _isSubscriber;
  bool get isSubscriber => _isSubscriber;

  // Future<void> subscribe(String name) async {
  //   if (isSubscriber) return;

  //   // _isLoading = true;
  //   // notifyListeners();

  //   try {
  //     await redditApi.subscribe(name);
  //     _isSubscriber = !isSubscriber;
  //   } on Exception catch (e) {
  //     _log.error(e);
  //     _error = e;
  //   }

  //   // _isLoading = false;
  //   notifyListeners();
  // }

  // Future<void> unsubscribe(String name) async {
  //   if (!isSubscriber) return;

  //   // _isLoading = true;
  //   // notifyListeners();

  //   try {
  //     await redditApi.unsubscribe(name);
  //     _isSubscriber = !isSubscriber;
  //   } on Exception catch (e) {
  //     _log.error(e);
  //     _error = e;
  //   }

  //   // _isLoading = false;
  //   notifyListeners();
  // }

  Future<String?> subscribe(String name) async {
    if (isSubscriber) return null;

    // _isLoading = true;
    // notifyListeners();

    try {
      await redditApi.subscribe(name);
      _isSubscriber = !isSubscriber;
      notifyListeners();
    } on Exception catch (e) {
      _log.error(e);
      return 'Error: Fail to subscribe';
    }

    // _isLoading = false;
  }

  Future<String?> unsubscribe(String name) async {
    if (!isSubscriber) return null;

    // _isLoading = true;
    // notifyListeners();

    try {
      await redditApi.unsubscribe(name);
      _isSubscriber = !isSubscriber;
      notifyListeners();
    } on Exception catch (e) {
      _log.error(e);
      return 'Error: Fail to unsubscribe';
    }

    // _isLoading = false;
  }
}

// TODO: add LoadingMixin, disable/enable button
// TODO: replace to ErrorMixin
abstract class VoteNotifier extends ChangeNotifier /* with Error<Object> */ {
  VoteNotifier(this.redditApi, Vote vote, int score)
      : _vote = vote,
        _score = score;

  int _score;
  int get score => _score;

  final RedditApi redditApi;
  static final _log = Logger('VoteNotifier');

  // Object? _error;
  // Object? get error {
  //   final tmp = _error;
  //   _error = null;
  //   return tmp;
  // }

  Vote _vote;
  Vote get vote => _vote;

  Future<String?> upVote(String id) async {
    await _updateVote(id, Vote.up);
  }

  Future<String?> downVote(String id) async {
    await _updateVote(id, Vote.down);
  }

  Future<String?> clearVote(String id) async {
    await _updateVote(id, Vote.none);
  }

  Future<String?> _updateVote(String id, Vote vote) async {
    if (_vote == vote) return null;

    try {
      // await redditApi.submissionVote(id, vote);
      await _doVote(id, vote);
      _updateScore(vote);
      _vote = vote;
      notifyListeners();
    } on Exception catch (e) {
      _log.error(e);
      // _error = e;
      return 'Error: fail to vote';
    }
  }

  void _updateScore(Vote newVote) {
    if (_vote == Vote.up) {
      if (newVote == Vote.down) {
        _score = _score - 2;
      } else if (newVote == Vote.none) {
        _score = _score - 1;
      }
    } else if (_vote == Vote.none) {
      if (newVote == Vote.down) {
        _score = _score - 1;
      } else if (newVote == Vote.up) {
        _score = _score + 1;
      }
    } else if (_vote == Vote.down) {
      if (newVote == Vote.up) {
        _score = _score + 2;
      } else if (newVote == Vote.none) {
        _score = _score + 1;
      }
    }
  }

  Future<void> _doVote(String id, Vote vote);
}

class SubmissionVoteNotifier extends VoteNotifier {
  SubmissionVoteNotifier(RedditApi redditApi, Submission submission)
      : super(redditApi, submission.likes, submission.score);

  @override
  Future<void> _doVote(String id, Vote vote) {
    return redditApi.submissionVote(id, vote);
  }
}

class CommentVoteNotifier extends VoteNotifier {
  CommentVoteNotifier(RedditApi redditApi, Comment comment)
      : super(redditApi, comment.likes, comment.score);

  @override
  Future<void> _doVote(String id, Vote vote) {
    return redditApi.commentVote(id, vote);
  }
}

/* abstract class SaveNotifier extends ChangeNotifier
    with Error<String>, Result<String> {
  SaveNotifier(this.redditApi, bool saved) : _saved = saved;

  bool _saved;
  bool get saved => _saved;

  final RedditApi redditApi;
  static final _log = Logger('SaveNotifier');

  // Object? _error;
  // Object? get error {
  //   final tmp = _error;
  //   _error = null;
  //   return tmp;
  // }

  Future<void> save(String id) async {
    print(_saved);
    if (_saved) return;

    try {
      // throw Exception('some save error');
      await _doSave(id);
      _saved = true;
      _result = 'Saved';
    } on Exception catch (e) {
      _log.error(e);
      _error = 'Fail to save';
    }

    notifyListeners();
  }

  Future<void> unsave(String id) async {
    print(_saved);
    if (!_saved) return;

    try {
      // throw Exception('some unsave error');
      await _doUnsave(id);
      _saved = false;
      _result = 'Unsaved';
    } on Exception catch (e) {
      _log.error(e);
      _error = 'Fail to unsave';
    }

    notifyListeners();
  }

  Future<void> _doSave(String id);
  Future<void> _doUnsave(String id);
} */

abstract class SaveNotifier extends ChangeNotifier {
  SaveNotifier(this.redditApi, bool saved) : _saved = saved;

  bool _saved;
  bool get saved => _saved;

  final RedditApi redditApi;
  static final _log = Logger('SaveNotifier');

  // Future<Result<String, String>> save(String id) async {
  //   if (_saved) return Result.empty();

  //   try {
  //     // throw Exception('some save error');
  //     await _doSave(id);
  //     _saved = true;
  //     notifyListeners();
  //     return Result.value('Saved');
  //   } on Exception catch (e) {
  //     _log.error(e);
  //     return Result.error('Fail to save');
  //   }
  // }

  // Future<Result<String, String>> unsave(String id) async {
  //   if (!_saved) return Result.empty();
  //   try {
  //     // throw Exception('some unsave error');
  //     await _doUnsave(id);
  //     _saved = false;
  //     notifyListeners();
  //     return Result.value('Unsaved');
  //   } on Exception catch (e) {
  //     _log.error(e);
  //     return Result.error('Fail to unsave');
  //   }
  // }

  Future<String?> save(String id) async {
    if (_saved) return null;

    try {
      // throw Exception('some save error');
      await _doSave(id);
      _saved = true;
      notifyListeners();
      return 'Saved';
    } on Exception catch (e) {
      _log.error(e);
      return 'Error: Fail to save';
    }
  }

  Future<String?> unsave(String id) async {
    if (!_saved) return null;

    try {
      await _doUnsave(id);
      _saved = false;
      notifyListeners();
      return 'Unsaved';
    } on Exception catch (e) {
      _log.error(e);
      return 'Error: Fail to unsave';
    }
  }

  Future<void> _doSave(String id);
  Future<void> _doUnsave(String id);
}

/* abstract class SaveNotifier extends ChangeNotifier {
  SaveNotifier(this.redditApi, bool saved) : _saved = saved;

  bool _saved;
  bool get saved => _saved;

  final RedditApi redditApi;
  static final _log = Logger('SaveNotifier');

  Future<String?> save(String id) async {
    if (_saved) return null;

    try {
      // throw Exception('some save error');
      await _doSave(id);
      _saved = true;
      notifyListeners();
      return 'Saved';
    } on Exception catch (e) {
      _log.error(e);
      throw UIException('Fail to save');
    }
  }

  Future<String?> unsave(String id) async {
    if (!_saved) return null;
    try {
      // throw Exception('some unsave error');
      await _doUnsave(id);
      _saved = false;
      notifyListeners();
      return 'Unsaved';
    } on Exception catch (e) {
      _log.error(e);
      throw UIException('Fail to unsave');
    }
  }

  Future<void> _doSave(String id);
  Future<void> _doUnsave(String id);
}

class UIException implements Exception {
  UIException(this.message);

  String message;

  @override
  String toString() => message;
} */

class SubmissionSaveNotifier extends SaveNotifier {
  SubmissionSaveNotifier(RedditApi redditApi, Submission submission)
      : super(redditApi, submission.saved);

  @override
  Future<void> _doSave(String id) {
    return redditApi.submissionSave(id);
  }

  @override
  Future<void> _doUnsave(String id) {
    return redditApi.submissionUnsave(id);
  }
}

class CommentSaveNotifier extends SaveNotifier {
  CommentSaveNotifier(RedditApi redditApi, Comment comment)
      : super(redditApi, comment.saved);

  @override
  Future<void> _doSave(String id) {
    return redditApi.commentSave(id);
  }

  @override
  Future<void> _doUnsave(String id) {
    return redditApi.commentUnsave(id);
  }
}

class SubmissionNotifier extends ChangeNotifier {
  SubmissionNotifier(this.redditApi, this.submission);

  Submission submission;
  final RedditApi redditApi;

  static final _log = Logger('Submission');

  // Future<Submission> load(String id) async {
  //   _log.info('load submission');
  //   return redditApi.submission(id);
  // }

  // Future<void> submissionReply(String id, String body) async {
  //   await redditApi.submissionReply(id, body);
  //   notifyListeners();
  // }

  // Future<void> commentReply(String id, String body) async {
  //   await redditApi.commentReply(id, body);
  //   notifyListeners();
  // }

  Future<String?> save() async {
    if (submission.saved) return null;

    try {
      await redditApi.submissionSave(submission.id);
      submission = submission.copyWith(saved: true);
      notifyListeners();
      return 'Saved';
    } on Exception catch (e) {
      _log.error(e);
      return 'Error: Fail to save';
    }
  }

  Future<String?> unsave() async {
    if (!submission.saved) return null;

    try {
      await redditApi.commentUnsave(submission.id);
      submission = submission.copyWith(saved: false);
      notifyListeners();
      return 'Unsaved';
    } on Exception catch (e) {
      _log.error(e);
      return 'Error: Fail to unsave';
    }
  }

  Future<void> share() {
    return Share.share('${submission.title} ${submission.shortLink}');
  }

  Future<String?> reply(String body) async {
    print('reply');
    try {
      final commentReply = await redditApi.submissionReply(submission.id, body);
      submission = submission.copyWith(
        numComments: submission.numComments + 1,
        comments: submission.comments + [commentReply],
        // comments: [commentReply] + submission.comments,
      );
      notifyListeners();
      return null;
    } on Exception catch (e) {
      _log.error(e);
      return 'Fail to post comment';
    }
  }

  Future<String?> upVote() async {
    if (submission.likes == Vote.up) {
      return _updateVote(Vote.none);
    }
    return await _updateVote(Vote.up);
  }

  Future<String?> downVote() async {
    if (submission.likes == Vote.down) {
      return _updateVote(Vote.none);
    }
    return await _updateVote(Vote.down);
  }

  // Future<String?> clearVote() async {
  //   return await _updateVote(Vote.none);
  // }

  Future<String?> _updateVote(Vote vote) async {
    if (submission.likes == vote) return null;

    try {
      await redditApi.submissionVote(submission.id, vote);
      submission = submission.copyWith(
        likes: vote,
        score: calcScore(submission.score, submission.likes, vote),
      );
      notifyListeners();
      return null;
    } on Exception catch (e) {
      _log.error(e);
      // _error = e;
      return 'Error: fail to vote';
    }
  }

  // Future<String?> commentReply(String id, String body) async {
  //   try {
  //     await redditApi.commentReply(id, body);
  //     notifyListeners();
  //     return null;
  //   } on Exception catch (e) {
  //     _log.error(e);
  //     return 'Fail to post comment';
  //   }
  // }
}

// class RedditNotifierFront extends ChangeNotifier {
//   RedditNotifierFront(this.redditApi);

//   final RedditApi redditApi;
//   SubType _type = SubType.best;

//   SubType get type => _type;

//   set type(SubType type) {
//     _type = type;
//     notifyListeners();
//   }

//   Stream<Submission> front({int limit = 10}) {
//     print(_type);
//     return redditApi.front(limit: limit, type: _type);
//   }
// }

////////////////////////////////////////////////////////////////
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

mixin VoteMixin {
  static late final Logger _log;

  late int _score;
  int get score => _score;

  late Vote _vote;
  Vote get vote => _vote;

  Future<String?> upVote(String id) async {
    await _updateVote(id, Vote.up);
  }

  Future<String?> downVote(String id) async {
    await _updateVote(id, Vote.down);
  }

  Future<String?> clearVote(String id) async {
    await _updateVote(id, Vote.none);
  }

  Future<String?> _updateVote(String id, Vote vote) async {
    if (_vote == vote) return null;

    try {
      // await redditApi.submissionVote(id, vote);
      await _doVote(id, vote);
      _updateScore(vote);
      _vote = vote;
      notifyListeners();
    } on Exception catch (e) {
      _log.error(e);
      // _error = e;
      return 'Error: fail to vote';
    }
  }

  void _updateScore(Vote newVote) {
    if (_vote == Vote.up) {
      if (newVote == Vote.down) {
        _score = _score - 2;
      } else if (newVote == Vote.none) {
        _score = _score - 1;
      }
    } else if (_vote == Vote.none) {
      if (newVote == Vote.down) {
        _score = _score - 1;
      } else if (newVote == Vote.up) {
        _score = _score + 1;
      }
    } else if (_vote == Vote.down) {
      if (newVote == Vote.up) {
        _score = _score + 2;
      } else if (newVote == Vote.none) {
        _score = _score + 1;
      }
    }
  }

  Future<void> _doVote(String id, Vote vote);
  void notifyListeners();
}

mixin SaveMixin {
  late bool _saved;
  bool get saved => _saved;

  static late final _log;

  Future<String?> save(String id) async {
    if (_saved) return null;

    try {
      await _doSave(id);
      _saved = true;
      notifyListeners();
      return 'Saved';
    } on Exception catch (e) {
      _log.error(e);
      return 'Error: Fail to save';
    }
  }

  Future<String?> unsave(String id) async {
    if (!_saved) return null;

    try {
      await _doUnsave(id);
      _saved = false;
      notifyListeners();
      return 'Unsaved';
    } on Exception catch (e) {
      _log.error(e);
      return 'Error: Fail to unsave';
    }
  }

  Future<void> _doSave(String id);
  Future<void> _doUnsave(String id);
  void notifyListeners();
}

/* class CommentNotifier extends ChangeNotifier
    with CollapseMixin, VoteMixin, SaveMixin {
  CommentNotifier(this.redditApi, this.comment) {
    _saved = comment.saved;
    _score = comment.score;
    _vote = comment.likes;
  }

  final RedditApi redditApi;
  Comment comment;

  static final _log = Logger('CommentNotifier');

  @override
  Future<void> _doVote(String id, Vote vote) {
    return redditApi.commentVote(id, vote);
  }

  @override
  Future<void> _doSave(String id) {
    return redditApi.commentSave(id);
  }

  @override
  Future<void> _doUnsave(String id) {
    return redditApi.commentUnsave(id);
  }
} */

// class CommentNotifier extends ChangeNotifier with CollapseMixin {
class CommentNotifier with CollapseMixin, ChangeNotifier {
  CommentNotifier(this.redditApi, this.comment);

  final RedditApi redditApi;
  Comment comment;

  static final _log = Logger('CommentNotifier');

  Future<void> share() {
    return Share.share('${comment.linkTitle} ${comment.shortLink}');
  }

  Future<String?> reply(String body) async {
    try {
      // throw Exception('error');
      final commentReply = await redditApi.commentReply(comment.id, body);
      print(commentReply);
      comment = comment.copyWith(replies: [commentReply] + comment.replies);
      notifyListeners();
      return null;
    } on Exception catch (e) {
      _log.error(e);
      return 'Error: Fail to reply';
    }
  }

  Future<String?> save() async {
    if (comment.saved) return null;

    try {
      await redditApi.commentSave(comment.id);
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
      await redditApi.commentUnsave(comment.id);
      comment = comment.copyWith(saved: false);
      notifyListeners();
      return 'Unsaved';
    } on Exception catch (e) {
      _log.error(e);
      return 'Error: Fail to unsave';
    }
  }

  // Future<String?> upVote() async {
  //   return await _updateVote(Vote.up);
  // }

  // Future<String?> downVote() async {
  //   return await _updateVote(Vote.down);
  // }

  // Future<String?> clearVote() async {
  //   return await _updateVote(Vote.none);
  // }

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

  // Future<String?> clearVote() async {
  //   return await _updateVote(Vote.none);
  // }

  Future<String?> _updateVote(Vote vote) async {
    if (comment.likes == vote) return null;

    try {
      await redditApi.submissionVote(comment.id, vote);
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
