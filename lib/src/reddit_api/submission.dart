import 'package:draw/draw.dart' as draw;
import 'package:equatable/equatable.dart';

import 'call.dart';
import 'comment.dart';
import 'like.dart';

import 'post_hint.dart';
import 'preview_images.dart';
import 'video.dart';

class Submission extends Equatable {
  const Submission({
    required this.author,
    required this.created,
    required this.createdUtc,
    required this.domain,
    required this.downs,
    required this.hidden,
    required this.id,
    required this.isVideo,
    required this.linkFlairText,
    required this.authorFlairText,
    required this.numComments,
    required this.over18,
    required this.pinned,
    required this.score,
    required this.selftext,
    required this.subreddit,
    required this.subredditNamePrefixed,
    required this.thumbnail,
    required this.title,
    required this.ups,
    required this.url,
    required this.awardIcons,
    required this.totalAwardsReceived,
    required this.likes,
    required this.saved,
    required this.comments,
    required this.preview,
    required this.video,
    required this.postHint,
    required this.authorIsBlocked,
    required this.drawSubmission,
  });

  final String author;
  final DateTime created;
  final DateTime createdUtc;
  final String domain;
  final int downs;
  final bool hidden;
  final String id;
  final bool isVideo;
  final String linkFlairText;
  final String authorFlairText;
  final int numComments;
  final bool over18;
  final bool pinned;
  final int score;
  final String selftext;
  final String subreddit;
  final String subredditNamePrefixed;
  final String thumbnail;
  final String title;
  final int ups;
  final String url;
  final List<String> awardIcons;
  final int totalAwardsReceived;
  final Like likes;
  final bool saved;
  final List<Comment>? comments;
  final List<Preview> preview;
  final Video? video;
  final PostHint postHint;
  final bool authorIsBlocked;
  final draw.Submission? drawSubmission;

  String get shortLink => id == '' ? '' : 'https://redd.it/$id';

  @override
  List<Object?> get props {
    return [
      author,
      created,
      createdUtc,
      domain,
      downs,
      hidden,
      id,
      isVideo,
      linkFlairText,
      authorFlairText,
      numComments,
      over18,
      pinned,
      score,
      selftext,
      subreddit,
      subredditNamePrefixed,
      thumbnail,
      title,
      ups,
      url,
      awardIcons,
      totalAwardsReceived,
      likes,
      saved,
      comments,
      preview,
      video,
      postHint,
      authorIsBlocked,
      drawSubmission,
    ];
  }

  Submission copyWith({
    String? author,
    DateTime? created,
    DateTime? createdUtc,
    String? domain,
    int? downs,
    bool? hidden,
    String? id,
    bool? isVideo,
    String? linkFlairText,
    String? authorFlairText,
    int? numComments,
    bool? over18,
    bool? pinned,
    int? score,
    String? selftext,
    String? subreddit,
    String? subredditNamePrefixed,
    String? thumbnail,
    String? title,
    int? ups,
    String? url,
    List<String>? awardIcons,
    int? totalAwardsReceived,
    Like? likes,
    bool? saved,
    List<Comment>? Function()? comments,
    List<Preview>? preview,
    Video? Function()? video,
    PostHint? postHint,
    bool? authorIsBlocked,
    draw.Submission? Function()? drawSubmission,
  }) {
    return Submission(
      author: author ?? this.author,
      created: created ?? this.created,
      createdUtc: createdUtc ?? this.createdUtc,
      domain: domain ?? this.domain,
      downs: downs ?? this.downs,
      hidden: hidden ?? this.hidden,
      id: id ?? this.id,
      isVideo: isVideo ?? this.isVideo,
      linkFlairText: linkFlairText ?? this.linkFlairText,
      authorFlairText: authorFlairText ?? this.authorFlairText,
      numComments: numComments ?? this.numComments,
      over18: over18 ?? this.over18,
      pinned: pinned ?? this.pinned,
      score: score ?? this.score,
      selftext: selftext ?? this.selftext,
      subreddit: subreddit ?? this.subreddit,
      subredditNamePrefixed:
          subredditNamePrefixed ?? this.subredditNamePrefixed,
      thumbnail: thumbnail ?? this.thumbnail,
      title: title ?? this.title,
      ups: ups ?? this.ups,
      url: url ?? this.url,
      awardIcons: awardIcons ?? this.awardIcons,
      totalAwardsReceived: totalAwardsReceived ?? this.totalAwardsReceived,
      likes: likes ?? this.likes,
      saved: saved ?? this.saved,
      comments: tryCall(comments) ?? this.comments,
      preview: preview ?? this.preview,
      video: tryCall(video) ?? this.video,
      postHint: postHint ?? this.postHint,
      authorIsBlocked: authorIsBlocked ?? this.authorIsBlocked,
      drawSubmission: tryCall(drawSubmission) ?? this.drawSubmission,
    );
  }
}
