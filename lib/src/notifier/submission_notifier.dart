import 'package:flutter/foundation.dart' show ChangeNotifier;

import 'package:flutter_reddit_prototype/src/notifier/iterable_sum.dart';
import 'package:flutter_reddit_prototype/src/notifier/replyable.dart';
import 'package:flutter_reddit_prototype/src/notifier/reportable.dart';
import 'package:flutter_reddit_prototype/src/notifier/savable.dart';
import 'package:flutter_reddit_prototype/src/notifier/try_mixin.dart';
import 'package:share_plus/share_plus.dart';

import '../logging.dart';
import '../reddit_api/comment.dart';
import '../reddit_api/like.dart';
import '../reddit_api/preview_images.dart';
import '../reddit_api/reddit_api.dart';
import '../reddit_api/submission.dart';
import 'comment_notifier.dart';
import 'likable.dart';
import 'property_listener.dart';
import 'score.dart';

class PreviewImage {
  final PreviewItem image;
  final PreviewItem preview;
  PreviewImage(this.image, this.preview);
}

class SubmissionNotifier
    with TryMixin, Likable, Savable, ChangeNotifier
    implements Reportable, Replyable {
  SubmissionNotifier(this._redditApi, this._submission) {
    _setComments(_submission.comments);
  }

  String get id => _submission.id;

  final RedditApi _redditApi;
  static final _log = getLogger('SubmissionNotifier');
  Logger get log => _log;

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
    return try_(() async {
      if (_comments != null) return;
      _submission = await _redditApi.submission(id);
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

  String get replyToMessage => _submission.title;

  Future<void> reply(String body) {
    return try_(() async {
      final commentReply = await _redditApi.submissionReply(id, body);

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

  Future<void> _updateSave(bool save) {
    return try_(() async {
      await (save
          ? _redditApi.submissionSave
          : _redditApi.submissionUnsave)(id);
      _submission = _submission.copyWith(saved: save);
      notifyListeners();
    }, 'fail to' + (save ? 'save' : 'unsave'));
  }

  Future<void> hide() {
    return _updateHide(true);
  }

  Future<void> unhide() {
    return _updateHide(false);
  }

  Future<void> _updateHide(bool hide) {
    return try_(() async {
      if (_submission.hidden == hide) return;
      await (hide
          ? _redditApi.submissionHide
          : _redditApi.submissionUnhide)(id);
      _submission = _submission.copyWith(hidden: hide);
      notifyListeners();
    }, 'fail to' + (hide ? 'hide' : 'unhide'));
  }

  @override
  Like get likes => _submission.likes;

  @override
  int get score => _submission.score;

  Future<void> updateLike_(Like like) {
    return try_(() async {
      await _redditApi.submissionLike(id, like);
      _submission = _submission.copyWith(
        likes: like,
        score: calcScore(_submission.score, _submission.likes, like),
      );
      notifyListeners();
    }, 'fail to like');
  }

  Future<void> share() {
    return try_(() async {
      await Share.share('${_submission.title} ${_submission.shortLink}');
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

  @override
  Future<void> report(String reason) {
    return try_(() async {
      await _redditApi.submissionReport(id, reason);
      notifyListeners();
    }, 'fail to report');
  }

  // Future<void> userBlock() {
  //   return _updateUserBlock(true);
  // }

  // Future<void> userUnblock() {
  //   return _updateUserBlock(false);
  // }

  // Future<void> _updateUserBlock(bool block) {
  //   return try_(() async {
  //     if (_submission.authorIsBlocked == block) return;
  //     await (block
  //         ? _redditApi.userBlock
  //         : _redditApi.userUnblock)(_submission.author);
  //     _submission = _submission.copyWith(authorIsBlocked: block);
  //     notifyListeners();
  //   }, 'fail to' + (block ? 'block' : 'unblock'));
  // }
}
