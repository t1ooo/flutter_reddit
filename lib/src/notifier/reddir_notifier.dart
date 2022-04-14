import 'package:draw/draw.dart' as draw;
import 'package:flutter/foundation.dart';

import '../logging/logging.dart';
import '../reddit_api/trophy.dart';
import '../reddit_api/user.dart';
import '../reddit_api/comment.dart';
import '../reddit_api/reddir_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import '../reddit_api/subreddit.dart';
import '../reddit_api/vote.dart';

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

class RedditNotifier extends ChangeNotifier {
  RedditNotifier(this.redditApi);

  final RedditApi redditApi;

  // TODO: rename to front
  Stream<Submission> front({int limit = 10, SubType type = SubType.best}) {
    return redditApi.front(limit: limit, type: type);
  }

  Stream<Submission> popular({int limit = 10, SubType type = SubType.best}) {
    return redditApi.popular(limit: limit, type: type);
  }

  Stream<Subreddit> userSubreddits({int limit = 10}) {
    return redditApi.userSubreddits(limit: limit);
    // ..sort((a, b) => a.displayName.compareTo(b.displayName));
  }

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

class SubscriptionNotifier extends ChangeNotifier {
  SubscriptionNotifier(this.redditApi, bool isSubscriber)
      : _isSubscriber = isSubscriber;

  final RedditApi redditApi;
  static final _log = Logger('SubscriptionNotifier');

  // bool _isLoading = false;
  // bool get isLoading => _isLoading;

  Object? _error;
  Object? get error {
    final tmp = _error;
    _error = null;
    return tmp;
  }

  bool _isSubscriber;
  bool get isSubscriber => _isSubscriber;

  Future<void> subscribe(String name) async {
    if (isSubscriber) return;

    // _isLoading = true;
    // notifyListeners();

    try {
      await redditApi.subscribe(name);
      _isSubscriber = !isSubscriber;
    } on Exception catch (e) {
      _log.error(e);
      _error = e;
    }

    // _isLoading = false;
    notifyListeners();
  }

  Future<void> unsubscribe(String name) async {
    if (!isSubscriber) return;

    // _isLoading = true;
    // notifyListeners();

    try {
      await redditApi.unsubscribe(name);
      _isSubscriber = !isSubscriber;
    } on Exception catch (e) {
      _log.error(e);
      _error = e;
    }

    // _isLoading = false;
    notifyListeners();
  }
}

// TODO: add LoadingMixin, disable/enable button
// TODO: replace to ErrorMixin
abstract class VoteNotifier extends ChangeNotifier {
  VoteNotifier(this.redditApi, Vote vote, int upvotes) : 
  _vote = vote,
  _upvotes = upvotes;

  int _upvotes;
  int get upvotes => _upvotes;

  final RedditApi redditApi;
  static final _log = Logger('VoteNotifier');

  Object? _error;
  Object? get error {
    final tmp = _error;
    _error = null;
    return tmp;
  }

  Vote _vote;
  Vote get vote => _vote;

  Future<void> upVote(String id) async {
    await _updateVote(id, Vote.up);
  }

  Future<void> downVote(String id) async {
    await _updateVote(id, Vote.down);
  }

  Future<void> clearVote(String id) async {
    await _updateVote(id, Vote.none);
  }

  Future<void> _updateVote(String id, Vote vote) async {
    if (_vote == vote) return;

    try {
      // await redditApi.submissionVote(id, vote);
      await _doVote(id, vote);
      _updateUpvotes(vote);
      _vote = vote;
    } on Exception catch (e) {
      _log.error(e);
      _error = e;
    }

    notifyListeners();
  }

  void _updateUpvotes(Vote newVote) {
    if (_vote == Vote.up) {
      if (newVote == Vote.down) {
        _upvotes = _upvotes - 2;
      } else if (newVote == Vote.none) {
        _upvotes = _upvotes - 1;
      }
    } else if (_vote == Vote.none) {
      if (newVote == Vote.down) {
        _upvotes = _upvotes - 1;
      } else if (newVote == Vote.up) {
        _upvotes = _upvotes + 1;
      }
    } else if (_vote == Vote.down) {
      if (newVote == Vote.up) {
        _upvotes = _upvotes + 2;
      } else if (newVote == Vote.none) {
        _upvotes = _upvotes + 1;
      }
    }
  }

  Future<void> _doVote(String id, Vote vote);
}

class SubmissionVoteNotifier extends VoteNotifier {
  SubmissionVoteNotifier(RedditApi redditApi, Vote vote, int upvotes)
      : super(redditApi, vote, upvotes);

  @override
  Future<void> _doVote(String id, Vote vote) {
    return redditApi.submissionVote(id, vote);
  }
}

// class CommentVoteNotifier extends VoteNotifier {
//   CommentNotifier(RedditApi redditApi, Comment comment)
//       : super(redditApi, comment.likes, comment.upvotes);

//   @override
//   Future<void> _doVote(String id, Vote vote) {
//     return redditApi.submissionVote(id, vote);
//   }
// }

// class CommentVoteNotifier extends VoteNotifier {
//   CommentVoteNotifier(RedditApi redditApi, Vote vote) : super(redditApi, vote);

//   @override
//   Future<void> _doVote(String id, Vote vote) {
//     return redditApi.commentVote(id, vote);
//   }
// }









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
