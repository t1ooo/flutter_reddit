import 'package:draw/draw.dart' show CommentForest;
import 'package:equatable/equatable.dart';
import 'package:flutter_reddit_prototype/src/reddit_api/preview_images.dart';

import '../logging/logging.dart';
import 'parse.dart';
import 'comment.dart';
import 'vote.dart';
import 'submission_type.dart';

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
    required this.upvotes,
    required this.url,
    required this.awardIcons,
    required this.totalAwardsReceived,
    required this.likes,
    // required this.type,
    required this.comments,
    required this.saved,
    required this.preview,
    // required this.shortLink,
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
  final int upvotes;
  final String url;
  final List<String> awardIcons;
  final int totalAwardsReceived;
  final Vote likes;
  final bool saved;
  // final SubType? type;
  // final CommentForest? comments;
  final List<Comment>? comments;
  // final String shortLink;
  final List<PreviewImages> preview;

  // static final _log = getLogger('Submission');

  // static const _descLen = 200;
  // String get desc {
  //   final text = selftext.replaceAll(RegExp(r'\s+'), ' ');
  //   // return selftext.length <= _descLen ? selftext : selftext.substring(0, _descLen);
  //   return text.length <= _descLen ? text : text.substring(0, _descLen) + '...';
  // }

  String get shortLink {
    if (id == '') {
      return '';
    }
    return 'https://redd.it/$id';
  }

  // factory Submission.fromDrawSubmission(draw.Submission sub, {required SubType type}) {
  factory Submission.fromJson(
    Map data, {
    // SubType? type,
    // CommentForest? comments,
    List<Comment>? comments,
  }) {
    return Submission(
      author: mapGet(data, 'author', '', _log),
      authorFlairText: mapGet(data, 'author_flair_text', '', _log),
      awardIcons: parseAwardIcons(data['all_awardings'], _log),
      created: parseTime(data['created'], false, _log),
      createdUtc: parseTime(data['created_utc'], true, _log),
      domain: mapGet(data, 'domain', '', _log),
      downs: mapGet(data, 'downs', 0, _log),
      // edited: mapGet(data, 'edited', 0, _log),
      hidden: mapGet(data, 'hidden', false, _log),
      id: mapGet(data, 'id', '', _log),
      isVideo: mapGet(data, 'is_video', false, _log),
      linkFlairText: mapGet(data, 'link_flair_text', '', _log),
      totalAwardsReceived: mapGet(data, 'total_awards_received', 0, _log),
      numComments: mapGet(data, 'num_comments', 0, _log),
      over18: mapGet(data, 'over_18', false, _log),
      pinned: mapGet(data, 'pinned', false, _log),
      score: mapGet(data, 'score', 0, _log),
      selftext: mapGet(data, 'selftext', '', _log),
      subreddit: mapGet(data, 'subreddit', '', _log),
      subredditNamePrefixed: mapGet(data, 'subreddit_name_prefixed', '', _log),
      thumbnail: parseUrl(data['thumbnail'], _log),
      title: mapGet(data, 'title', '', _log),
      upvotes: mapGet(data, 'ups', 0, _log),
      url: parseUrl(data['url'], _log),
      likes: parseLikes(data['likes'], _log),
      saved: mapGet(data, 'saved', false, _log),
      // shortLink: _genShortLink(mapGet(data, 'id', '')),
      // type: type,
      preview: parseSubmissionPreview(data['preview']?['images']),
      comments: comments,
    );
  }

  static final _log = getLogger('Submission');

  // static String _genShortLink(String id) {
  //   if (id == '') {
  //     return '';
  //   }
  //   return 'https://redd.it/$id';
  // }

  @override
  List<Object?> get props {
    return [
      author,
      created,
      createdUtc,
      domain,
      downs,
      // edited,
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
      upvotes,
      url,
      awardIcons,
      totalAwardsReceived,
      likes,
      // type,
      comments,
      saved,
      shortLink,
      preview,
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
    int? upvotes,
    String? url,
    List<String>? awardIcons,
    int? totalAwardsReceived,
    Vote? likes,
    bool? saved,
    SubType? type,
    List<Comment>? comments,
    List<PreviewImages>? preview,
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
      upvotes: upvotes ?? this.upvotes,
      url: url ?? this.url,
      awardIcons: awardIcons ?? this.awardIcons,
      totalAwardsReceived: totalAwardsReceived ?? this.totalAwardsReceived,
      likes: likes ?? this.likes,
      saved: saved ?? this.saved,
      // type: type ?? this.type,
      comments: comments ?? this.comments,
      preview: preview ?? this.preview,
    );
  }
}

// Submission placeholderSubmission() {
//   return Submission(
//     author: 'author',
//     created: DateTime.now(),
//     createdUtc: DateTime.now(),
//     domain: 'domain',
//     downs: 0,
//     // edited: 0,
//     hidden: false,
//     id: 'id',
//     isVideo: false,
//     linkFlairText: 'linkFlairText',
//     authorFlairText: 'authorFlairText',
//     numComments: 0,
//     over18: false,
//     pinned: true,
//     score: 0,
//     selftext: 'selftext',
//     subreddit: 'subreddit',
//     subredditNamePrefixed: 'subredditNamePrefixed',
//     thumbnail: 'thumbnail',
//     title: 'title',
//     upvotes: 0,
//     url: 'https://example.com',
//     awardIcons: [],
//     totalAwardsReceived: 0,
//     likes: Vote.none,
//     type: SubType.best,
//     comments: [],
//     saved: false,
//     // shortLink: '',
//   );
// }
