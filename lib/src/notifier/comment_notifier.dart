import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter_reddit_prototype/src/notifier/iterable_sum.dart';
import 'package:flutter_reddit_prototype/src/notifier/replyable.dart';
import 'package:flutter_reddit_prototype/src/notifier/reportable.dart';

import '../logging/logging.dart';
import '../reddit_api/comment.dart';
import '../reddit_api/like.dart';
import '../reddit_api/reddit_api.dart';
import 'collapse_mixin.dart';
import 'likable_mixin.dart';
import 'property_listener.dart';
import 'savable_mixin.dart';
import 'score.dart';
import 'try_mixin.dart';

class CommentNotifier
    with Try, Collapse, ChangeNotifier, Likable, Savable
    implements Reportable, Replyable {
  CommentNotifier(this._redditApi, this._comment) {
    _replies = _comment.replies
        .map((v) => _addListener(CommentNotifier(_redditApi, v)))
        .toList();
  }

  final RedditApi _redditApi;

  static final _log = getLogger('CommentNotifier');

  Comment _comment;
  Comment get comment => _comment;

  late final List<CommentNotifier> _replies;
  List<CommentNotifier> get replies => _replies;

  int get numReplies {
    return (_replies.isEmpty)
        ? _comment.numComments
        : _replies.map((v) => 1 + v.numReplies).sum();
  }

  Future<void> copyText() {
    return try_(() {
      return Clipboard.setData(ClipboardData(text: _comment.body));
    }, 'fail to copy');
  }

  bool get saved => _comment.saved;

  Future<void> _updateSave(bool save) {
    return try_(() async {
      await (save
          ? _redditApi.commentSave
          : _redditApi.commentUnsave)(comment.id);
      _comment = comment.copyWith(saved: save);
      notifyListeners();
    }, 'fail to ' + (save ? 'save' : 'unsave'));
  }

  @override
  Like get likes => _comment.likes;

  @override
  int get score => _comment.score;

  Future<void> updateLike_(Like like) {
    _log.info('updateLike_($like)');
    return try_(() async {
      await _redditApi.commentLike(comment.id, like);
      _comment = comment.copyWith(
        likes: like,
        score: calcScore(comment.score, comment.likes, like),
      );
      notifyListeners();
    }, 'fail to like');
  }

  Future<void> share() {
    return try_(() async {
      await Share.share('${_comment.linkTitle} ${_comment.shortLink}');
    }, 'fail to share');
  }

  String get replyToMessage => _comment.body;

  Future<void> reply(String body) async {
    return try_(() async {
      final commentReply = await _redditApi.commentReply(_comment.id, body);

      _replies.insert(0, CommentNotifier(_redditApi, commentReply));
      notifyListeners();
    }, 'fail to reply');
  }

  CommentNotifier _addListener(CommentNotifier t) {
    return t
      ..addPropertyListener<int>(() => t.numReplies, () {
        print('update');
        notifyListeners();
      });
  }

  @override
  Future<void> report(String reason) {
    return try_(() async {
      await _redditApi.submissionReport(comment.id, reason);
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
  //     if (_comment.authorIsBlocked == block) return;
  //     await (block
  //         ? _redditApi.userBlock
  //         : _redditApi.userUnblock)(_comment.author);
  //     _comment = _comment.copyWith(authorIsBlocked: block);
  //     notifyListeners();
  //   }, 'fail to' + (block ? 'block' : 'unblock'));
  // }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}
