import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../logging/logging.dart';
import '../reddit_api/comment.dart';
import '../reddit_api/message.dart';
import '../reddit_api/reddir_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_image.dart';
import '../reddit_api/submission_type.dart';
import '../reddit_api/subreddit.dart';
import '../reddit_api/trophy.dart';
import '../reddit_api/user.dart';
import '../reddit_api/vote.dart';

// abstract class VoteNotifer with TryMixin {
//   Future<void> updateVote(Vote vote) async {
//     return _try(() async {
//       if (likes == vote) return null;

//       await _vote(vote);
//       comment = comment.copyWith(
//         likes: vote,
//         score: calcScore(comment.score, comment.likes, vote),
//       );
//       notifyListeners();
//     }, 'fail to vote');
//   }
// }

class SearchNotifierQ extends ChangeNotifier with TryMixin {
  SearchNotifierQ(this._redditApi) {
    reset();
  }

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = getLogger('SearchNotifierQX');

  void reset() {
    _subredditName = '';
    _query = '';
    _sort = Sort.relevance;
    _submissions = null;
    notifyListeners();
  }

  late String _subredditName;
  late String _query;

  late Sort _sort;
  Sort get sort => _sort;

  List<Sort> get sorts => Sort.values;

  late List<SubmissionNotifierQ>? _submissions;
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
          _subredditName == subredditName) return;

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
    }, 'fail to search');
  }
}

class SearchSubredditsQ extends ChangeNotifier with TryMixin {
  SearchSubredditsQ(this._redditApi) {
    reset();
  }

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = getLogger('SearchSubredditsQ');

  void reset() {
    _query = '';
    _subreddits = null;
    notifyListeners();
  }

  late String _query;

  List<Sort> get sorts => Sort.values;

  late List<SubredditNotifierQ>? _subreddits;
  List<SubredditNotifierQ>? get subreddits => _subreddits;

  Future<void> search(
    String query, [
    Sort sort = Sort.relevance,
    String subredditName = 'all',
  ]) {
    return _try(() async {
      if (_subreddits != null && _query == query) return;

      _query = query;

      _subreddits =
          (await _redditApi.searchSubreddits(query, limit: _limit).toList())
              .map((v) => SubredditNotifierQ(_redditApi, v))
              .toList();
      notifyListeners();
    }, 'fail to search subreddits');
  }
}

class SubredditLoaderNotifierQ extends ChangeNotifier with TryMixin {
  SubredditLoaderNotifierQ(this._redditApi) {
    reset();
  }

  final RedditApi _redditApi;
  static final _log = getLogger('SubredditNotifierQ');

  void reset() {
    _name = null;
    _subreddit = null;
    notifyListeners();
  }

  late String? _name;

  late SubredditNotifierQ? _subreddit;
  SubredditNotifierQ? get subreddit => _subreddit;

  Future<void> loadSubreddit(String name) {
    return _try(() async {
      if (_subreddit != null && _name == name) return;
      _name = name;

      // if (_name != name) _subreddit = null;
      // _name = name;
      // if (_subreddit != null) return null;
      _subreddit =
          SubredditNotifierQ(_redditApi, await _redditApi.subreddit(_name!));
      notifyListeners();
    }, 'fail to load subreddit');
  }
}

class SubredditNotifierQ extends ChangeNotifier with TryMixin {
  SubredditNotifierQ(this._redditApi, this._subreddit,
      [this.isUserSubreddit = false])
      : name = _subreddit.displayName;

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = getLogger('SubredditNotifierQ');

  // set name(name);

  final bool isUserSubreddit;

  final String name;
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
      await _redditApi.subscribe(name);
      _subreddit = _subreddit.copyWith(userIsSubscriber: true);
      notifyListeners();
    }, 'fail to subscribe');
  }

  Future<void> unsubscribe() {
    return _try(() async {
      if (!(_subreddit.userIsSubscriber)) return;
      await _redditApi.subscribe(name);
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

  SubType _subType = SubType.values.first;
  SubType get subType => _subType;

  List<SubmissionNotifierQ>? _submissions;
  List<SubmissionNotifierQ>? get submissions => _submissions;

  Future<void> loadSubmissions(SubType subType) {
    return _try(() async {
      if (_submissions != null && _subType == subType) return;
      _subType = subType;
      _submissions = await _redditApi
          .subredditSubmissions(name, limit: _limit, type: _subType)
          .map((v) => SubmissionNotifierQ(_redditApi, v))
          .toList();
      notifyListeners();
    }, 'fail to load subreddit submissions');
  }

  Future<SubmissionNotifierQ> submit({
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
      return SubmissionNotifierQ(_redditApi, submission);
      // notifyListeners();
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
}

// TODO: move to current user
class HomeFrontNotifierQ extends ChangeNotifier with TryMixin {
  HomeFrontNotifierQ(this._redditApi) {
    reset();
  }

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = getLogger('HomeFrontNotifierQ');

  void reset() {
    _subType = FrontSubType.values.first;
    _submissions = null;
    notifyListeners();
  }

  late FrontSubType _subType;
  FrontSubType get subType => _subType;

  late List<SubmissionNotifierQ>? _submissions;
  List<SubmissionNotifierQ>? get submissions => _submissions;

  Future<void> loadSubmissions(FrontSubType subType) {
    return _try(() async {
      if (_submissions != null && _subType == subType) return;
      _subType = subType;

      _submissions =
          (await _redditApi.front(limit: _limit, type: _subType).toList())
              .map((v) => SubmissionNotifierQ(_redditApi, v))
              .toList();
      notifyListeners();
    }, 'fail to search');
  }
}

class HomePopularNotifierQ extends ChangeNotifier with TryMixin {
  HomePopularNotifierQ(this._redditApi) {
    reset();
  }

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = getLogger('HomePopularNotifierQ');

  void reset() {
    _subType = SubType.values.first;
    _submissions = null;
    notifyListeners();
  }

  late SubType _subType;
  SubType get subType => _subType;

  late List<SubmissionNotifierQ>? _submissions;
  List<SubmissionNotifierQ>? get submissions => _submissions;

  Future<void> loadSubmissions(SubType subType) {
    return _try(() async {
      if (_submissions != null && _subType == subType) return;
      _subType = subType;

      _submissions =
          (await _redditApi.popular(limit: _limit, type: _subType).toList())
              .map((v) => SubmissionNotifierQ(_redditApi, v))
              .toList();
      notifyListeners();
    }, 'fail to search');
  }
}

// class SubmissionLoaderNotifierQ extends ChangeNotifier with TryMixin {
//   SubmissionLoaderNotifierQ(this._redditApi) {
//     reset();
//   }

//   final RedditApi _redditApi;
//   static final _log = getLogger('SubmissionNotifierQ');

//   void reset() {
//     _id = null;
//     _submission = null;
//     notifyListeners();
//   }

//   late String? _id;

//   late SubmissionNotifierQ? _submission;
//   SubmissionNotifierQ? get submission => _submission;

//   Future<void> loadSubmission(String id) {
//     return _try(() async {
//       if (_submission != null && _id == id) return;
//       _id = id;
//       _submission =
//           SubmissionNotifierQ(_redditApi, await _redditApi.submission(_id!));
//       // _setComments(_submission?.comments);
//       notifyListeners();
//     }, 'fail to load submission');
//   }
// }

class SubmissionNotifierQ extends ChangeNotifier with TryMixin {
  SubmissionNotifierQ(this._redditApi, this._submission) {
    _setComments(_submission.comments);
  }

  // final String _id;

  final RedditApi _redditApi;
  static final _log = getLogger('SubmissionNotifierQ');

  late List<CommentNotifierQ>? _comments;
  List<CommentNotifierQ>? get comments => _comments;

  Submission _submission;
  Submission get submission => _submission;

  int get numReplies {
    // if (_comments.isEmpty) return _submission.numComments;
    if (_comments == null) return _submission.numComments;
    int num = 0;
    for (final comment in _comments!) {
      num += 1 + comment.numReplies;
    }
    return num;
  }

  Future<void> loadComments() {
    return _try(() async {
      if (_comments != null) return;
      _submission = await _redditApi.submission(_submission.id);
      _setComments(_submission.comments);
      notifyListeners();
    }, 'fail to load comments');
  }

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
    // if (comments == null) {
    //   _comments = [];
    //   return;
    // }
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

  Future<void> reply(String body) {
    return _try(() async {
      final commentReply =
          await _redditApi.submissionReply(submission.id, body);
      // _comments!.add(CommentNotifierQ(_redditApi, commentReply));
      _comments ??= [];
      _comments!.insert(0, CommentNotifierQ(_redditApi, commentReply));
      notifyListeners();
    }, 'fail to reply');
  }

  // TODO: save unsave
  Future<void> save() {
    return _try(() async {
      if (submission.saved) return;

      await _redditApi.submissionSave(submission.id);
      _submission = submission.copyWith(saved: true);
      notifyListeners();
    }, 'fail to save');
  }

  Future<void> unsave() {
    return _try(() async {
      if (!submission.saved) return;

      await _redditApi.submissionSave(submission.id);
      _submission = submission.copyWith(saved: false);
      notifyListeners();
    }, 'fail to unsave');
  }

  Future<void> voteUp() {
    return _updateSubmissionsVote(Vote.up);
  }

  Future<void> voteDown() {
    return _updateSubmissionsVote(Vote.down);
  }

  Future<void> _updateSubmissionsVote(Vote vote) {
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
    }, 'fail to vote');
  }

  Future<void> share() {
    return _try(() async {
      await Share.share('${submission.title} ${submission.shortLink}');
    }, 'fail to share');
  }

  SizedImage? previewImage([
    double minWidth = 0,
    double maxWidth = double.infinity,
  ]) {
    final images_ = images(minWidth, maxWidth);
    // print(images_.map((x)=>x.width).toList());
    return images_.isEmpty ? null : images_.first;
  }

  List<SizedImage> images([
    double minWidth = 0,
    double maxWidth = double.infinity,
  ]) {
    return _submission.preview
        .map((v) {
          // print(v.resolutions);
          final resolutions = v.resolutions
              .where(
                (r) =>
                    r.url != '' && minWidth <= r.width && r.width <= maxWidth,
              )
              .toList();
          resolutions.sort((a, b) => (b.width - a.width).toInt());
          // print(resolutions.map((x) => x.width).toList());
          return resolutions.isEmpty ? null : resolutions.first;
        })
        .whereType<SizedImage>()
        .toList();

    // final images = <String>[];
    // for (final sImage in _submission.preview) {
    //   for (final resolution in sImage.resolutions) {
    //     if (resolution.url != '' &&
    //         resolution.width >= minWidth &&
    //         resolution.width <= maxWidth) {
    //       images.add(resolution.url);
    //       break;
    //     }
    //   }
    // }
    // return images;
  }

  /*  String? _icon;
  String? get icon => _icon;

  Future<void> loadIcon() {
    return _try(() async {
      if (_icon != null) return;
      _icon = await _redditApi.subredditIcon(_submission.subreddit);
      notifyListeners();
    }, 'fail to load icon');
  }

  SubredditNotifierQ? _subreddit;
  SubredditNotifierQ? get subreddit => _subreddit;

  Future<void> loadSubreddit() {
    return _try(() async {
      if (subreddit != null) return;
      _subreddit = SubredditNotifierQ(
          _redditApi, await _redditApi.subreddit(_submission.subreddit));
      notifyListeners();
    }, 'fail to load subreddit');
  } */

  // Future<void> loadIcon([String? defaultIcon]) {
  //   final fn = () async {
  //     throw Exception();
  //     if (_icon != null) return;
  //     _icon = await _redditApi.subredditIcon(_submission.subreddit);
  //     notifyListeners();
  //   };

  //   if (defaultIcon != null) {
  //     return _tryOr(fn, defaultIcon);
  //   }
  //   return _try(fn, 'fail to load icon');
  // }

  void refresh() => notifyListeners();
}

class CommentNotifierQ with TryMixin, CollapseMixin, ChangeNotifier {
  CommentNotifierQ(this._redditApi, this._comment)
      : _replies = _comment.replies
            .map((v) => CommentNotifierQ(_redditApi, v))
            .toList();

  final RedditApi _redditApi;
  // Comment comment;
  static final _log = getLogger('SubmissionNotifierQ');

  Comment _comment;
  Comment get comment => _comment;

  final List<CommentNotifierQ> _replies;
  List<CommentNotifierQ> get replies => _replies;

  int get numReplies {
    if (_replies.isEmpty) return _comment.numComments;
    int num = 0;
    for (final comment in _replies) {
      num += 1 + comment.numReplies;
    }
    return num;
  }

  Future<void> copyText() {
    return _try(() {
      return Clipboard.setData(ClipboardData(text: _comment.body));
    }, 'fail to copy');
  }

  Future<void> save() {
    return _try(() async {
      if (_comment.saved) return;
      await _redditApi.commentSave(_comment.id);
      _comment = comment.copyWith(saved: true);
      notifyListeners();
    }, 'fail to save');
  }

  Future<void> unsave() {
    return _try(() async {
      if (!_comment.saved) return;
      await _redditApi.commentUnsave(comment.id);
      _comment = comment.copyWith(saved: false);
      notifyListeners();
    }, 'fail to unsave');
  }

  Future<void> upVote() async {
    if (_comment.likes == Vote.up) {
      return _updateVote(Vote.none);
    }
    return await _updateVote(Vote.up);
  }

  Future<void> downVote() async {
    if (_comment.likes == Vote.down) {
      return _updateVote(Vote.none);
    }
    return await _updateVote(Vote.down);
  }

  Future<void> _updateVote(Vote vote) {
    return _try(() async {
      if (comment.likes == vote) return;

      await _redditApi.commentVote(comment.id, vote);
      _comment = comment.copyWith(
        likes: vote,
        score: calcScore(comment.score, comment.likes, vote),
      );
      notifyListeners();
    }, 'fail to vote');
  }

  Future<void> share() {
    return _try(() async {
      await Share.share('${_comment.linkTitle} ${_comment.shortLink}');
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
      final commentReply = await _redditApi.commentReply(_comment.id, body);
      // comment = comment.copyWith(replies: [commentReply] + comment.replies);
      // _replies.add(CommentNotifierQ(_redditApi, commentReply));
      _replies.insert(0, CommentNotifierQ(_redditApi, commentReply));
      notifyListeners();
    }, 'fail to reply');
  }
}

class UserLoaderNotifierQ extends ChangeNotifier with TryMixin {
  UserLoaderNotifierQ(this._redditApi) {
    reset();
  }

  final RedditApi _redditApi;
  // int _limit = 10;
  static final _log = getLogger('UserLoaderNotifierQ');

  void reset() {
    _name = null;
    _user = null;
    notifyListeners();
  }

  // void _reset() {
  //   _user = null;
  // }

  late String? _name;

  // void _setName(String name) {
  //   if (_name != name) _reset();
  //   _name = name;
  // }

  late UserNotifierQ? _user;
  UserNotifierQ? get user => _user;

  // SubredditNotifierQ? _subreddit;
  // SubredditNotifierQ? get subreddit => _subreddit;

  Future<void> loadUser(String name) {
    // print(name);
    return _try(() async {
      if (_user != null && _name == name) return;
      _name = name;
      // _setName(name);
      // if (_user != null) return null;
      // final user = await _redditApi.user(_name!);
      _user = UserNotifierQ(_redditApi, await _redditApi.user(_name!));
      // _subreddit = SubredditNotifierQ(_redditApi, user.subreddit);
      notifyListeners();
    }, 'fail to load user');
  }
}

class UserNotifierQ extends ChangeNotifier with TryMixin {
  UserNotifierQ(this._redditApi, this._user, [this.isCurrentUser = false])
      : _name = _user.name,
        _subreddit = SubredditNotifierQ(_redditApi, _user.subreddit, true);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = getLogger('UserNotifierQ');

  // void _reset() {
  //   _user = null;
  //   _submissions = null;
  //   _comments = null;
  //   _trophies = null;
  // }

  final bool isCurrentUser;

  final String _name;

  // void _setName(String name) {
  //   if (_name != name) _reset();
  //   _name = name;
  // }

  final SubredditNotifierQ _subreddit;
  SubredditNotifierQ get subreddit => _subreddit;

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

  // Future<void> subscribe() {
  //   return _try(() async {
  //     if (user.subreddit.userIsSubscriber) return null;
  //     await _redditApi.subscribe(user.subreddit.displayName);
  //     notifyListeners();
  //   }, 'fail to subscribe');
  // }

  // Future<void> unsubscribe() {
  //   return _try(() async {
  //     if (!(user.subreddit.userIsSubscriber)) return null;
  //     await _redditApi.subscribe(user.subreddit.displayName);
  //     notifyListeners();
  //   }, 'fail to unsubscribe');
  // }

  List<SubmissionNotifierQ>? _submissions;
  List<SubmissionNotifierQ>? get submissions => _submissions;
  Future<void> loadSubmissions() {
    return _try(() async {
      if (_submissions != null) return;
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
      if (_comments != null) return;
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
      if (_trophies != null) return;
      _trophies = await _redditApi.userTrophies(_name);
      notifyListeners();
    }, 'fail to load user comments');
  }

  // UserSaved? _saved;
  List<CommentNotifierQ>? _savedComments;
  List<CommentNotifierQ>? get savedComments =>
      _savedComments?.where((v) => v.comment.saved).toList();
  List<SubmissionNotifierQ>? _savedSubmissions;
  List<SubmissionNotifierQ>? get savedSubmissions =>
      _savedSubmissions?.where((v) => v.submission.saved).toList();

  Future<void> loadSaved() {
    return _try(() async {
      if (_savedComments != null && _savedSubmissions != null) return;
      final saved = await _redditApi.userSaved(_user.name, limit: _limit);
      _savedSubmissions = saved.submissions
          .map((v) => SubmissionNotifierQ(_redditApi, v))
          .toList();
      _savedComments =
          saved.comments.map((v) => CommentNotifierQ(_redditApi, v)).toList();
      notifyListeners();
    }, 'fail to load saved');
  }
}

// TODO: rename to AuthNotifier
// TODO: merge with CurrentUserNotifier?
class UserAuth extends ChangeNotifier with TryMixin {
  UserAuth(this._redditApi);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = getLogger('UserAuth');

  CurrentUserNotifierQ? _user;
  CurrentUserNotifierQ? get user => _user;

  // late bool _isLoggedIn;
  // bool get isLoggedIn => _redditApi.isLoggedIn();

  // String? _authUrl;
  // String? get authUrl => _authUrl;

  Future<bool> loginSilently(String name, String pass) async {
    // print('loginSilently');
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
    _user = CurrentUserNotifierQ(_redditApi, user);
  }

  // Future<void> ___login(String name, String pass) async {
  //   return _try(() async {
  //     final authUrl = await _redditApi.authUrl();
  //     if (authUrl != null) {
  //       launchUrl(authUrl);
  //       await _redditApi.auth();
  //     }
  //     final user = await _redditApi.currentUser();
  //     if (user == null) {
  //       throw Exception('user is null');
  //     }
  //     _user = CurrentUserNotifierQ(_redditApi, user);
  //     notifyListeners();
  //   }, 'fail to login');
  // }

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
}

// class CurrentUserNotifierQ extends ChangeNotifier with TryMixin {
class CurrentUserNotifierQ extends UserNotifierQ {
  // CurrentUserNotifierQ(this._redditApi, this._user)
  CurrentUserNotifierQ(this._redditApi, User user)
      : super(_redditApi, user, true);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = getLogger('CurrentUserNotifierQ');

  // User _user;
  // User get user => _user;

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

  SubredditNotifierQ? _all;
  SubredditNotifierQ? get all => _all;

  List<SubredditNotifierQ>? _subreddits;
  List<SubredditNotifierQ>? get subreddits => _subreddits;
  // List<SubredditNotifierQ>? get favoriteSubreddits =>
  //     _subreddits?.where((v) => v.subreddit.userHasFavorited).toList();
  // List<SubredditNotifierQ>? get unfavoriteSubreddits =>
  //     _subreddits?.where((v) => !v.subreddit.userHasFavorited).toList();

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
    _all = SubredditNotifierQ(_redditApi, await _redditApi.subreddit('all'));
    notifyListeners();
  }

  Future<void> _loadSubreddits() async {
    if (_subreddits != null) {
      return;
    }
    _subreddits = await _redditApi
        .currentUserSubreddits(limit: _limit)
        .map((v) => SubredditNotifierQ(_redditApi, v))
        .toList();
    notifyListeners();
  }

  static List<SubredditNotifierQ> filterFavorite(
          List<SubredditNotifierQ> subreddits) =>
      subreddits.where((v) => v.subreddit.userHasFavorited).toList();

  static List<SubredditNotifierQ> filterUnfavorite(
          List<SubredditNotifierQ> subreddits) =>
      subreddits.where((v) => !v.subreddit.userHasFavorited).toList();

  List<MessageNotifierQ>? _inboxMessages;
  List<MessageNotifierQ>? get inboxMessages => _inboxMessages;

  Future<void> loadInboxMessages() {
    return _try(() async {
      if (_inboxMessages != null) {
        return;
      }
      _inboxMessages = await _redditApi
          .inboxMessages()
          .map((v) => MessageNotifierQ(_redditApi, v))
          .toList();
      notifyListeners();
    }, 'fail to load inbox messages');
  }

  // List<CommentNotifierQ>? _savedComments;
  // List<CommentNotifierQ>? get savedComments => _savedComments;

  // Future<void> loadSavedComments() {
  //   {
  //     return _try(() async {
  //       _savedComments = await _redditApi
  //           .userComments(_user.name, limit: _limit)
  //           .map((v) => CommentNotifierQ(_redditApi, v))
  //           .toList();
  //       notifyListeners();
  //     }, 'fail to login');
  //   }
  // }

  // List<SubmissionNotifierQ>? _savedSubmissions;
  // List<SubmissionNotifierQ>? get savedSubmissions => _savedSubmissions;

  // Future<void> loadSavedSubmissions() {
  //   {
  //     return _try(() async {
  //       _savedSubmissions = await _redditApi
  //           .userSubmissions(_user.name, limit: _limit)
  //           .map((v) => SubmissionNotifierQ(_redditApi, v))
  //           .toList();
  //       notifyListeners();
  //     }, 'fail to load saved submissions');
  //   }
  // }

  // Future<SubmissionNotifierQ> submit({
  //   required String subreddit,
  //   required String title,
  //   String? selftext,
  //   String? url,
  //   bool resubmit = true,
  //   bool sendReplies = true,
  //   bool nsfw = false,
  //   bool spoiler = false,
  // }) async {
  //   return _try(() async {
  //     final submission = await _redditApi.submit(
  //       subreddit: subreddit,
  //       title: title,
  //       selftext: selftext,
  //       url: url,
  //       resubmit: resubmit,
  //       sendReplies: sendReplies,
  //       nsfw: nsfw,
  //       spoiler: spoiler,
  //     );
  //     return SubmissionNotifierQ(_redditApi, submission);
  //     // notifyListeners();
  //   }, 'fail to submit');
  // }

  void refresh() => notifyListeners();
}

class MessageNotifierQ extends ChangeNotifier with TryMixin {
  MessageNotifierQ(this._redditApi, this._message);

  final RedditApi _redditApi;
  static final _log = getLogger('MessageNotifierQ');

  Message _message;
  Message get message => _message;
}

class UIException implements Exception {
  UIException(this._message);
  String _message;
  String toString() => _message;
}

mixin TryMixin {
  // static late final Logger _log;
  static final _log = getLogger('TryMixin');

  // Future<void> _try(Future<void> Function() fn, String error) async {
  //   try {
  //     return await fn();
  //   } on Exception catch (e, st) {
  //     _log.error('', e, st);
  //     return error;
  //   }
  // }

  // Future<void> _try(Future<void> Function() fn, String error) async {
  //   try {
  //     return await fn();
  //   } on Exception catch (e, st) {
  //     _log.error('', e, st);
  //     throw UIException(error);
  //   }
  // }

  Future<T> _try<T>(Future<T> Function() fn, String error) async {
    try {
      return await fn();
    } on Exception catch (e, st) {
      _log.error('', e, st);
      throw UIException(error);
    }
  }

  // Future<T> _tryOr<T>(Future<T> Function() fn, T defaultValue) async {
  //   try {
  //     return await fn();
  //   } on Exception catch (e, st) {
  //     _log.error('', e, st);
  //     return defaultValue;
  //   }
  // }
}

// mixin LoggedInMixin {
//   late final RedditApi _redditApi;

//   Future<void> mustLoggedIn() async {
//     if (!(await _redditApi.isLoggedIn)) {
//       throw UIException('please, login to continue');
//     }
//   }
// }

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
