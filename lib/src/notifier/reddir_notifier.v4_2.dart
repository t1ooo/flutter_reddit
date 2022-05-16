import 'dart:collection';

import 'package:clock/clock.dart';
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

// abstract class LikeNotifer with TryMixin {
//   Future<void> updateLike(Like like) async {
//     return _try(() async {
//       if (likes == like) return null;

//       await _like(like);
//       comment = comment.copyWith(
//         likes: like,
//         score: calcScore(comment.score, comment.likes, like),
//       );
//       notifyListeners();
//     }, 'fail to like');
//   }
// }

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
  // Future<void> like();
  // Future<void> dislike();
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
  SearchNotifier(this._redditApi) {
    reset();
  }

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

  late String _subredditName;
  late String _query;

  late Sort _sort;
  Sort get sort => _sort;

  List<Sort> get sorts => Sort.values;

  late List<SubmissionNotifier>? _submissions;
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
    // _query = query;
    // _sort = sort;
    // _subredditName = subredditName;
    // _submissions = null;
    // notifyListeners();

    // try {
    //   _submissions =
    //       (await _redditApi.search(_query, limit: _limit, sort: _sort).toList())
    //           .map((v) => SubmissionNotifier(_redditApi, v))
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

  late List<SubredditNotifier>? _subreddits;
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

class SubredditLoaderNotifier extends ChangeNotifier with TryMixin {
  SubredditLoaderNotifier(this._redditApi) {
    reset();
  }

  final RedditApi _redditApi;
  static final _log = getLogger('SubredditNotifier');

  void reset() {
    _name = null;
    _subreddit = null;
    notifyListeners();
  }

  late String? _name;

  late SubredditNotifier? _subreddit;
  SubredditNotifier? get subreddit => _subreddit;

  Future<void> loadSubreddit(String name) {
    return _try(() async {
      if (_subreddit != null && _name == name) return;
      _name = name;

      // if (_name != name) _subreddit = null;
      // _name = name;
      // if (_subreddit != null) return null;
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
  ]) : super(_redditApi) {
    name = _subreddit.displayName;
    reset();
  }

  void reset() {
    _submissions = null;
    _subType = SubType.values.first;
    notifyListeners();
  }

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = getLogger('SubredditNotifier');

  // set name(name);

  final bool isUserSubreddit;

  late final String name;
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

  // SubType _subType = SubType.values.first;
  // SubType get subType => _subType;

  // List<SubmissionNotifier>? _submissions;
  // List<SubmissionNotifier>? get submissions => _submissions;

  // Future<void> reloadSubmissions() {
  //   _submissions = null;
  //   return loadSubmissions(_subType);
  // }

  // Future<void> loadSubmissions(SubType subType) {
  //   return _try(() async {
  //     if (_submissions != null && _subType == subType) return;
  //     _subType = subType;
  //     _submissions = await _redditApi
  //         .subredditSubmissions(name, limit: _limit, type: _subType)
  //         .map((v) => SubmissionNotifier(_redditApi, v))
  //         .toList();
  //     notifyListeners();
  //   }, 'fail to load subreddit submissions');
  // }

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

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

abstract class SubmissionsNotifier<T> extends ChangeNotifier with TryMixin {
  SubmissionsNotifier(this._redditApi);

  late final RedditApi _redditApi;
  // final Clock _clock;
  int _limit = 10;
  // static final _log = getLogger('HomeFrontNotifier');

  // void reset() {
  //   _subType = FrontSubType.values.first;
  //   _submissions = null;
  //   notifyListeners();
  // }

  late T _subType;
  T get subType => _subType;

  late List<SubmissionNotifier>? _submissions;
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

// abstract class SubmissionsNotifier<T> {
//   // SubmissionsNotifier(this._redditApi);

//   late final RedditApi _redditApi;
//   // final Clock _clock;
//   int _limit = 10;
//   // static final _log = getLogger('HomeFrontNotifier');

//   // void reset() {
//   //   _subType = FrontSubType.values.first;
//   //   _submissions = null;
//   //   notifyListeners();
//   // }

//   late T _subType;
//   T get subType => _subType;

//   late List<SubmissionNotifier>? _submissions;
//   List<SubmissionNotifier>? get submissions => _submissions;

//   Future<void> reloadSubmissions() {
//     _submissions = null;
//     return loadSubmissions(_subType);
//   }

//   Future<void> loadSubmissions(T subType) {
//     return _try(() async {
//       if (_submissions != null && _subType == subType) return;
//       _subType = subType;

//       _submissions = (await _loadSubmissions().toList())
//           .map((v) => SubmissionNotifier(_redditApi, v))
//           .toList();
//       notifyListeners();
//     }, 'fail to search');
//   }

//   void notifyListeners();
//   Stream<Submission> _loadSubmissions();
//   Future<T> _try<T>(Future<T> Function() fn, String error);
// }

class HomeFrontNotifier extends SubmissionsNotifier<FrontSubType> {
  HomeFrontNotifier(RedditApi redditApi) : super(redditApi) {
    reset();
  }

  static final _log = getLogger('HomeFrontNotifier');

  @override
  Stream<Submission> _loadSubmissions() {
    return _redditApi.front(limit: _limit, type: _subType);
  }

  void reset() {
    _subType = FrontSubType.values.first;
    _submissions = null;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

class HomePopularNotifier extends SubmissionsNotifier<SubType> {
  HomePopularNotifier(RedditApi redditApi) : super(redditApi) {
    reset();
  }

  static final _log = getLogger('HomeFrontNotifier');

  @override
  Stream<Submission> _loadSubmissions() {
    return _redditApi.popular(limit: _limit, type: _subType);
  }

  void reset() {
    _subType = SubType.values.first;
    _submissions = null;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

// TODO: move to current user
// class HomeFrontNotifier extends ChangeNotifier with TryMixin {
//   HomeFrontNotifier(
//     this._redditApi,
//     /* [this._clock = const Clock()] */
//   ) {
//     reset();
//   }

//   final RedditApi _redditApi;
//   // final Clock _clock;
//   int _limit = 10;
//   static final _log = getLogger('HomeFrontNotifier');

//   void reset() {
//     _subType = FrontSubType.values.first;
//     _submissions = null;
//     notifyListeners();
//   }

//   late FrontSubType _subType;
//   FrontSubType get subType => _subType;

//   late List<SubmissionNotifier>? _submissions;
//   List<SubmissionNotifier>? get submissions => _submissions;

//   DateTime lastModified = clock.now(); // TODO: remove
//   Duration _reloadDelay = Duration(seconds: 5);
//   bool get expired => _reloadDelay <= clock.now().difference(lastModified);

//   Future<void> reloadSubmissions() {
//     _submissions = null;
//     return loadSubmissions(_subType);
//   }

//   Future<void> loadSubmissions(FrontSubType subType) {
//     return _try(() async {
//       if (_submissions != null && _subType == subType) return;
//       _subType = subType;

//       _submissions =
//           (await _redditApi.front(limit: _limit, type: _subType).toList())
//               .map((v) => SubmissionNotifier(_redditApi, v))
//               .toList();
//       lastModified = clock.now();
//       notifyListeners();
//     }, 'fail to search');
//   }

//   @override
//   void notifyListeners() {
//     _log.info('notifyListeners');
//     super.notifyListeners();
//   }
// }

// class HomePopularNotifier extends ChangeNotifier with TryMixin {
//   HomePopularNotifier(this._redditApi) {
//     reset();
//   }

//   final RedditApi _redditApi;
//   int _limit = 10;
//   static final _log = getLogger('HomePopularNotifier');

//   void reset() {
//     _subType = SubType.values.first;
//     _submissions = null;
//     notifyListeners();
//   }

//   late SubType _subType;
//   SubType get subType => _subType;

//   late List<SubmissionNotifier>? _submissions;
//   List<SubmissionNotifier>? get submissions => _submissions;

//   Future<void> reloadSubmissions() {
//     _submissions = null;
//     return loadSubmissions(_subType);
//   }

//   Future<void> loadSubmissions(SubType subType) {
//     return _try(() async {
//       if (_submissions != null && _subType == subType) return;
//       _subType = subType;

//       _submissions =
//           (await _redditApi.popular(limit: _limit, type: _subType).toList())
//               .map((v) => SubmissionNotifier(_redditApi, v))
//               .toList();
//       notifyListeners();
//     }, 'fail to search');
//   }

//   @override
//   void notifyListeners() {
//     _log.info('notifyListeners');
//     super.notifyListeners();
//   }
// }

// class SubmissionLoaderNotifier extends ChangeNotifier with TryMixin {
//   SubmissionLoaderNotifier(this._redditApi) {
//     reset();
//   }

//   final RedditApi _redditApi;
//   static final _log = getLogger('SubmissionNotifier');

//   void reset() {
//     _id = null;
//     _submission = null;
//     notifyListeners();
//   }

//   late String? _id;

//   late SubmissionNotifier? _submission;
//   SubmissionNotifier? get submission => _submission;

//   Future<void> loadSubmission(String id) {
//     return _try(() async {
//       if (_submission != null && _id == id) return;
//       _id = id;
//       _submission =
//           SubmissionNotifier(_redditApi, await _redditApi.submission(_id!));
//       // _setComments(_submission?.comments);
//       notifyListeners();
//     }, 'fail to load submission');
//   }
// }

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

  // final String _id;

  final RedditApi _redditApi;
  static final _log = getLogger('SubmissionNotifier');

  late List<CommentNotifier>? _comments;
  List<CommentNotifier>? get comments => _comments;

  Submission _submission;
  Submission get submission => _submission;

  int get numReplies {
    return (_comments == null)
        ? _submission.numComments
        : _comments!.map((v) => 1 + v.numReplies).sum();

    // if (_comments == null) return _submission.numComments;
    // int num = 0;
    // for (final comment in _comments!) {
    //   num += 1 + comment.numReplies;
    // }
    // return num;
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

  // set submission(Submission? s) {
  //   if (_submission == s) return null;

  //   _submission = s;
  //   _id = _submission?.id;
  //   _comments = _submission?.comments.map((v) {
  //     return CommentNotifier(_redditApi, v);
  //   }).toList();

  //   notifyListeners();
  // }

  void _setComments(List<Comment>? comments) {
    // if (comments == null) {
    //   _comments = [];
    //   return;
    // }
    // CommentNotifier _addListenerRecursive(CommentNotifier cn) {
    //   _addListener(cn);
    //   cn.replies.forEach(_addListenerRecursive);
    //   return cn;
    // }

    // _comments = comments?.map((v) {
    //   return  _addListenerRecursive(CommentNotifier(_redditApi, v));
    // }).toList();

    _comments = comments?.map((v) {
      return _addListener(CommentNotifier(_redditApi, v));
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
      // _comments!.add(CommentNotifier(_redditApi, commentReply));
      _comments ??= [];
      _comments!
          .insert(0, _addListener(CommentNotifier(_redditApi, commentReply)));
      notifyListeners();
    }, 'fail to reply');
  }

  // T _addListener<T extends ChangeNotifier>(T t) {
  //   return t..addListener(() {
  //     print('update');
  //     notifyListeners();
  //   });
  // }

  CommentNotifier _addListener(CommentNotifier t) {
    // return t..addListener(notifyListeners);
    return t..addPropertyListener<int>(() => t.numReplies, notifyListeners);
  }

  // TODO: save unsave
  Future<void> save() {
    return _updateSave(true);
  }

  // Future<void> unsave() {
  //   return _updateSave(false);
  // }

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

  // @override
  // Future<void> like() async {
  //   if (_submission.likes == Like.up) {
  //     return _updateLike(Like.none);
  //   }
  //   return await _updateLike(Like.up);
  // }

  // @override
  // Future<void> dislike() async {
  //   if (_submission.likes == Like.down) {
  //     return _updateLike(Like.none);
  //   }
  //   return await _updateLike(Like.down);
  // }

  Future<void> _updateLike(Like like) {
    _log.info('_updateLike($like)');

    return _try(() async {
      // if (submission.likes == like) {
      // like = Like.none;
      // }

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

  // TODO: remove
  /* SizedPreview? previewImage([
    double minWidth = 0,
    double maxWidth = double.infinity,
  ]) {
    final images_ = images(minWidth, maxWidth);
    // print(images_.map((x)=>x.width).toList());
    return images_.isEmpty ? null : images_.first;
  } */

  // TODO: add height
  List<PreviewImage> images([
    // double minWidth = 0,
    double maxWidth = double.infinity,
    double maxHeight = double.infinity,
  ]) {
    return _submission.preview
        .map(
          (v) {
            // Preview items;
            // if (v.gifs != null) {
            //   items = v.gifs!;
            // } else if (v.images != null) {
            //   items = v.images!;
            // } else {
            //   return [];
            // }

            final resolutions = [v.source, ...v.resolutions.reversed];
            resolutions.sort((a, b) => (b.width - a.width).toInt());

            for (final img in resolutions) {
              // if (minWidth <= img.width && img.width <= maxWidth) {
              if (img.width <= maxWidth && img.width <= maxHeight) {
                return PreviewImage(v.source, img);
              }
            }

            return PreviewImage(v.source, v.source);

            // final resolutions = [items.source, ...items.resolutions]
            //     .where(
            //       (r) =>
            //           r.url != '' && minWidth <= r.width && r.width <= maxWidth,
            //     )
            //     .toList();
            // if (resolutions.isEmpty) {
            //   return null;
            // }
            // resolutions.sort((a, b) => (b.width - a.width).toInt());
            // return PreviewImage(items.source, resolutions.first);
          },
        )
        .whereType<PreviewImage>()
        .toList();
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

  SubredditNotifier? _subreddit;
  SubredditNotifier? get subreddit => _subreddit;

  Future<void> loadSubreddit() {
    return _try(() async {
      if (subreddit != null) return;
      _subreddit = SubredditNotifier(
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

  // void refresh() => notifyListeners();

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
  // Comment comment;
  static final _log = getLogger('CommentNotifier');

  Comment _comment;
  Comment get comment => _comment;

  late final List<CommentNotifier> _replies;
  List<CommentNotifier> get replies => _replies;

  int get numReplies {
    return (_replies.isEmpty)
        ? _comment.numComments
        : _replies.map((v) => 1 + v.numReplies).sum();

    // if (_replies.isEmpty) return _comment.numComments;
    // int num = 0;
    // for (final comment in _replies) {
    //   num += 1 + comment.numReplies;
    // }
    // return num;
  }

  Future<void> copyText() {
    return _try(() {
      return Clipboard.setData(ClipboardData(text: _comment.body));
    }, 'fail to copy');
  }

  // Future<void> save() {
  //   return _updateSave(true);
  // }

  // Future<void> unsave() {
  //   return _updateSave(false);
  // }

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

  // @override
  // Future<void> like() async {
  //   if (_comment.likes == Like.up) {
  //     return _updateLike(Like.none);
  //   }
  //   return await _updateLike(Like.up);
  // }

  // @override
  // Future<void> dislike() async {
  //   if (_comment.likes == Like.down) {
  //     return _updateLike(Like.none);
  //   }
  //   return await _updateLike(Like.down);
  // }

  Future<void> _updateLike(Like like) {
    _log.info('_updateLike($like)');
    return _try(() async {
      // if (comment.likes == like) return;
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
    // try {
    //   // throw Exception('error');
    //   final commentReply = await _redditApi.commentReply(comment.id, body);
    //   // comment = comment.copyWith(replies: [commentReply] + comment.replies);
    //   // _replies.add(CommentNotifier(_redditApi, commentReply));
    //   _replies.insert(0, CommentNotifier(_redditApi, commentReply));
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
      // _replies.add(CommentNotifier(_redditApi, commentReply));
      _replies.insert(0, CommentNotifier(_redditApi, commentReply));
      notifyListeners();
    }, 'fail to reply');
  }

  // T _addListener<T extends ChangeNotifier>(T t) {
  //   return t..addListener(notifyListeners);
  // }

  CommentNotifier _addListener(CommentNotifier t) {
    // return t..addListener(notifyListeners);
    return t
      ..addPropertyListener<int>(() => t.numReplies, () {
        print('update');
        notifyListeners();
      });
    // return t;
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

class UserLoaderNotifier extends ChangeNotifier with TryMixin {
  UserLoaderNotifier(this._redditApi) {
    reset();
  }

  final RedditApi _redditApi;
  // int _limit = 10;
  static final _log = getLogger('UserLoaderNotifier');

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

  late UserNotifier? _user;
  UserNotifier? get user => _user;

  // SubredditNotifier? _subreddit;
  // SubredditNotifier? get subreddit => _subreddit;

  Future<void> loadUser(String name) {
    // print(name);
    return _try(() async {
      if (_user != null && _name == name) return;
      _name = name;
      // _setName(name);
      // if (_user != null) return null;
      // final user = await _redditApi.user(_name!);
      _user = UserNotifier(_redditApi, await _redditApi.user(_name!));
      // _subreddit = SubredditNotifier(_redditApi, user.subreddit);
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

  final SubredditNotifier _subreddit;
  SubredditNotifier get subreddit => _subreddit;

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

  // UserSaved? _saved;
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
    _user = CurrentUserNotifier(_redditApi, user);
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
  //     _user = CurrentUserNotifier(_redditApi, user);
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

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}

// class CurrentUserNotifier extends ChangeNotifier with TryMixin {
class CurrentUserNotifier extends UserNotifier with PropertyListener {
  // CurrentUserNotifier(this._redditApi, this._user)
  CurrentUserNotifier(this._redditApi, User user)
      : super(_redditApi, user, true);

  final RedditApi _redditApi;
  int _limit = 10;
  static final _log = getLogger('CurrentUserNotifier');

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

  SubredditNotifier? _all;
  SubredditNotifier? get all => _all;

  List<SubredditNotifier>? _subreddits;
  List<SubredditNotifier>? get subreddits => _subreddits;
  // List<SubredditNotifier>? get favoriteSubreddits =>
  //     _subreddits?.where((v) => v.subreddit.userHasFavorited).toList();
  // List<SubredditNotifier>? get unfavoriteSubreddits =>
  //     _subreddits?.where((v) => !v.subreddit.userHasFavorited).toList();

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

  // T _addListener<T extends ChangeNotifier>(T t) {
  //   return t..addListener(notifyListeners);
  // }

  SubredditNotifier _addListener(SubredditNotifier t) {
    // return t..addListener(notifyListeners);
    return t
      ..addPropertyListener<bool>(() => t.subreddit.userHasFavorited, () {
        print('update');
        notifyListeners();
      });
    // return t;
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

  // List<CommentNotifier>? _savedComments;
  // List<CommentNotifier>? get savedComments => _savedComments;

  // Future<void> loadSavedComments() {
  //   {
  //     return _try(() async {
  //       _savedComments = await _redditApi
  //           .userComments(_user.name, limit: _limit)
  //           .map((v) => CommentNotifier(_redditApi, v))
  //           .toList();
  //       notifyListeners();
  //     }, 'fail to login');
  //   }
  // }

  // List<SubmissionNotifier>? _savedSubmissions;
  // List<SubmissionNotifier>? get savedSubmissions => _savedSubmissions;

  // Future<void> loadSavedSubmissions() {
  //   {
  //     return _try(() async {
  //       _savedSubmissions = await _redditApi
  //           .userSubmissions(_user.name, limit: _limit)
  //           .map((v) => SubmissionNotifier(_redditApi, v))
  //           .toList();
  //       notifyListeners();
  //     }, 'fail to load saved submissions');
  //   }
  // }

  // Future<SubmissionNotifier> submit({
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
  //     return SubmissionNotifier(_redditApi, submission);
  //     // notifyListeners();
  //   }, 'fail to submit');
  // }

  // void refresh() => notifyListeners();

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

// void addPropertyListener<T>(
//     ChangeNotifier notifier, T Function() select, void Function() listener) {
//   T value = select();
//   notifier.addListener(() {
//     final newValue = select();
//     if (value == newValue) {
//       return;
//     }
//     value = newValue;
//     listener();
//   });
// }

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
