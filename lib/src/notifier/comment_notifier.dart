import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../reddit_api/comment.dart';
import '../reddit_api/like.dart';
import '../reddit_api/reddit_api.dart';
import 'base_notifier.dart';
import 'collapsible.dart';
import 'iterable_sum.dart';
import 'likable.dart';
import 'replyable.dart';
import 'reportable.dart';
import 'savable.dart';
import 'score.dart';

class CommentNotifier extends BaseNotifier
    with Collapsible, Likable, Savable
    implements Reportable, Replyable {
  CommentNotifier(this._redditApi, this._comment) {
    _replies = _comment.replies
        .map((v) => _addListener(CommentNotifier(_redditApi, v)))
        .toList();
  }

  String get id => _comment.id;

  final RedditApi _redditApi;

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
    return try_(
      () {
        return Clipboard.setData(ClipboardData(text: _comment.body));
      },
      'fail to copy',
    );
  }

  @override
  bool get saved => _comment.saved;

  @override
  Future<void> save(bool save) {
    return try_(
      () async {
        if (_comment.saved == save) return;
        await _redditApi.commentSave(_comment, save);
        _comment = comment.copyWith(saved: save);
        notifyListeners();
      },
      'fail to ${save ? 'save' : 'unsave'}',
    );
  }

  @override
  Like get likes => _comment.likes;

  @override
  int get score => _comment.score;

  @override
  Future<void> updateLike_(Like like) {
    return try_(
      () async {
        await _redditApi.commentLike(_comment, like);
        _comment = _comment.copyWith(
          likes: like,
          score: calcScore(_comment.score, _comment.likes, like),
        );
        notifyListeners();
      },
      'fail to like',
    );
  }

  Future<void> share() {
    return try_(
      () async {
        await Share.share('${_comment.linkTitle} ${_comment.shortLink}');
      },
      'fail to share',
    );
  }

  @override
  String get replyToMessage => _comment.body;

  @override
  Future<void> reply(String body) async {
    return try_(
      () async {
        final commentReply = await _redditApi.commentReply(_comment, body);

        _replies.insert(0, CommentNotifier(_redditApi, commentReply));
        notifyListeners();
      },
      'fail to reply',
    );
  }

  CommentNotifier _addListener(CommentNotifier t) {
    return t
      ..addPropertyListener<int>(() => t.numReplies, () {
        notifyListeners();
      });
  }

  @override
  Future<void> report(String reason) {
    return try_(
      () async {
        await _redditApi.commentReport(_comment, reason);
        notifyListeners();
      },
      'fail to report',
    );
  }
}
