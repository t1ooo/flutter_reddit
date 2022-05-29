import 'package:share_plus/share_plus.dart';

import '../reddit_api/comment.dart';
import '../reddit_api/like.dart';
import '../reddit_api/preview_images.dart';
import '../reddit_api/reddit_api.dart';
import '../reddit_api/submission.dart';
import 'base_notifier.dart';
import 'comment_notifier.dart';
import 'iterable_sum.dart';
import 'likable.dart';
import 'replyable.dart';
import 'reportable.dart';
import 'savable.dart';

class PreviewImage {
  PreviewImage(this.image, this.preview);
  final PreviewItem image;
  final PreviewItem preview;
}

class SubmissionNotifier extends BaseNotifier
    with Likable, Savable
    implements Reportable, Replyable {
  SubmissionNotifier(this._redditApi, this._submission) {
    _setComments(_submission.comments);
  }

  String get id => _submission.id;

  final RedditApi _redditApi;

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
    return try_(
      () async {
        if (_comments != null) return;
        _submission = await _redditApi.submission(id);
        _setComments(_submission.comments);
        notifyListeners();
      },
      'fail to load comments',
    );
  }

  Future<void> loadComments() {
    return try_(
      () async {
        if (_comments != null) return;
        _setComments((await _redditApi.submission(id)).comments);
        notifyListeners();
      },
      'fail to load comments',
    );
  }

  void _setComments(List<Comment>? comments) {
    _comments = comments?.map((v) {
      return _addListener(CommentNotifier(_redditApi, v));
    }).toList();
  }

  @override
  String get replyToMessage => _submission.title;

  @override
  Future<void> reply(String body) {
    return try_(
      () async {
        final commentReply =
            await _redditApi.submissionReply(_submission, body);

        _comments ??= [];
        _comments!
            .insert(0, _addListener(CommentNotifier(_redditApi, commentReply)));
        notifyListeners();
      },
      'fail to reply',
    );
  }

  CommentNotifier _addListener(CommentNotifier t) {
    return t..addPropertyListener<int>(() => t.numReplies, notifyListeners);
  }

  @override
  bool get saved => _submission.saved;

  @override
  Future<void> save(bool save) {
    return try_(
      () async {
        if (_submission.saved == save) return;
        await _redditApi.submissionSave(_submission, save);
        _submission = _submission.copyWith(saved: save);
        notifyListeners();
      },
      'fail to${save ? 'save' : 'unsave'}',
    );
  }

  Future<void> hide(bool hide) {
    return try_(
      () async {
        if (_submission.hidden == hide) return;
        await _redditApi.submissionHide(_submission, hide);
        _submission = _submission.copyWith(hidden: hide);
        notifyListeners();
      },
      'fail to${hide ? 'hide' : 'unhide'}',
    );
  }

  // Future<void> optimisticUpdate({copy, update, restore, action}) async {
  //   final prev = copy();
  //   update();
  //   notifyListeners();
  //   try {
  //     await action();
  //   } on Exception catch (e, st) {
  //       restore();
  //     // onError(e, st);
  //     // ignore: avoid_catching_errors
  //   } on TypeError catch (e, st) {
  //     restore();
  //     notifyListeners();
  //   }
  // }

  // Future<void> hideOptimistically(bool hide) async {
  //   if (_submission.hidden == hide) return;

  //   optimisticUpdate(
  //     copy: () => _submission.copyWith(),
  //     update: () => _submission = _submission.copyWith(hidden: hide),
  //     restore: (prev) => _submission = prev,
  //     action: () =>  _redditApi.submissionHide(_submission, hide),
  //   );

  //   optimisticUpdate(
  //     values: () => [Value(_submission)],
  //     update: () => _submission = _submission.copyWith(hidden: hide),
  //     action: () =>  _redditApi.submissionHide(_submission, hide),
  //   );

  //   // final prev = _submission.copyWith();

  //   // _submission = _submission.copyWith(hidden: hide);
  //   // notifyListeners();

  //   // void onError(e, st) {
  //   //   _submission = prev;
  //   //   notifyListeners();
  //   //   throw Exception('fail to${hide ? 'hide' : 'unhide'}');
  //   // }

  //   // _try(() => _redditApi.submissionHide(_submission, hide), () {
  //   //   _submission = prev;
  //   //   notifyListeners();
  //   //   return 'fail to${hide ? 'hide' : 'unhide'}';
  //   // });

  //   // try {
  //   //   await _redditApi.submissionHide(_submission, hide);
  //   // } on Exception catch (e, st) {
  //   //   onError(e, st);
  //   //   // ignore: avoid_catching_errors
  //   // } on TypeError catch (e, st) {
  //   //   onError(e, st);
  //   // }
  //   // try {
  //   //   await _redditApi.submissionHide(_submission, hide);
  //   // } catch (e, st) {
  //   //   if (e is Exception || e is TypeError)
  //   //     onError(e, st);
  //   //   else
  //   //     rethrow;
  //   // }

  //   // await _redditApi
  //   //     .submissionHide(_submission, hide)
  //   //     .onError(onError, test: (e) => e is Exception || e is TypeError);

  //   // _try(()=>_redditApi.submissionHide(_submission, hide), () {
  //   //   _submission = prev;
  //   //   notifyListeners();
  //   //   return 'fail to${hide ? 'hide' : 'unhide'}';
  //   // });
  // }

  @override
  Like get likes => _submission.likes;

  @override
  int get score => _submission.score;

  @override
  Future<void> updateLike_(Like like) {
    return try_(
      () async {
        await _redditApi.submissionLike(_submission, like);
        _submission = _submission.setLike(like);
        notifyListeners();
      },
      'fail to like',
    );
  }

  Future<void> share() {
    return try_(
      () async {
        await Share.share('${_submission.title} ${_submission.shortLink}');
      },
      'fail to share',
    );
  }

  List<PreviewImage> images([
    double maxWidth = double.infinity,
    double maxHeight = double.infinity,
  ]) {
    return _submission.preview
        .map(
          (v) {
            final resolutions = [v.source, ...v.resolutions.reversed]
              ..sort((a, b) => (b.width - a.width).toInt());

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
  Future<void> report(String reason) {
    return try_(
      () async {
        await _redditApi.submissionReport(_submission, reason);
        notifyListeners();
      },
      'fail to report',
    );
  }
}


// class T extends Error implements Exception {}
