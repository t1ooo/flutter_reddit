import 'package:draw/draw.dart' show CommentForest;
import 'package:equatable/equatable.dart';

import '../util/map.dart';
import 'comment.dart';
import 'vote.dart';
import 'parse.dart';
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
    required this.type,
    required this.comments,
    required this.saved,
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
  final SubType? type;
  // final CommentForest? comments;
  final List<Comment> comments;
  // final String shortLink;

  // static final _log = Logger('Submission');

  static const _descLen = 200;
  String get desc {
    final text = selftext.replaceAll(RegExp(r'\s+'), ' ');
    // return selftext.length <= _descLen ? selftext : selftext.substring(0, _descLen);
    return text.length <= _descLen ? text : text.substring(0, _descLen) + '...';
  }

  String get shortLink {
    if (id == '') {
      return '';
    }
    return 'https://redd.it/$id';
  }

  // factory Submission.fromDrawSubmission(draw.Submission sub, {required SubType type}) {
  factory Submission.fromMap(
    Map data, {
    SubType? type,
    // CommentForest? comments,
    List<Comment> comments = const [],
  }) {
    return Submission(
      author: mapGet(data, 'author', ''),
      authorFlairText: mapGet(data, 'author_flair_text', ''),
      awardIcons: parseAwardIcons(data['all_awardings']),
      created: parseTime(data['created']),
      createdUtc: parseTime(data['created_utc'], isUtc: true),
      domain: mapGet(data, 'domain', ''),
      downs: mapGet(data, 'downs', 0),
      // edited: mapGet(data, 'edited', 0),
      hidden: mapGet(data, 'hidden', false),
      id: mapGet(data, 'id', ''),
      isVideo: mapGet(data, 'is_video', false),
      linkFlairText: mapGet(data, 'link_flair_text', ''),
      totalAwardsReceived: mapGet(data, 'total_awards_received', 0),
      numComments: mapGet(data, 'num_comments', 0),
      over18: mapGet(data, 'over_18', false),
      pinned: mapGet(data, 'pinned', false),
      score: mapGet(data, 'score', 0),
      selftext: mapGet(data, 'selftext', ''),
      subreddit: mapGet(data, 'subreddit', ''),
      subredditNamePrefixed: mapGet(data, 'subreddit_name_prefixed', ''),
      thumbnail: parseUrl(data['thumbnail']),
      title: mapGet(data, 'title', ''),
      upvotes: mapGet(data, 'ups', 0),
      url: parseUrl(data['url']),
      likes: parseLikes(data['likes']),
      saved: mapGet(data, 'saved', false),
      // shortLink: _genShortLink(mapGet(data, 'id', '')),
      type: type,
      comments: comments,
    );
  }

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
      type,
      comments,
      saved,
      shortLink,
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
      type: type ?? this.type,
      comments: comments ?? this.comments,
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
