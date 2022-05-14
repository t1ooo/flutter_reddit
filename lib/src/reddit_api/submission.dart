import 'package:draw/draw.dart' show CommentForest;
import 'package:equatable/equatable.dart';
import 'package:flutter_reddit_prototype/src/reddit_api/post_hint.dart';
import 'package:flutter_reddit_prototype/src/reddit_api/preview_images.dart';

import '../logging/logging.dart';
import 'nullable.dart';
import 'parse.dart';
import 'comment.dart';
import 'video.dart';
import 'likes.dart';
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
    required this.ups,
    required this.url,
    required this.awardIcons,
    required this.totalAwardsReceived,
    required this.likes,
    // required this.type,
    required this.comments,
    required this.saved,
    required this.preview,
    required this.video,
    required this.postHint,
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
  final int ups;
  final String url;
  final List<String> awardIcons;
  final int totalAwardsReceived;
  final Likes likes;
  final bool saved;
  // final SubType? type;
  // final CommentForest? comments;
  final List<Comment>? comments;
  // final String shortLink;
  // final List<Previews> preview;
  final List<Preview> preview;
  final Video? video;
  final PostHint postHint;

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
    Map m, {
    // SubType? type,
    // CommentForest? comments,
    List<Comment>? comments,
  }) {
    const f = 'Submission';
    return Submission(
      author: parseString(m['author'], '$f.author'),
      authorFlairText: parseString(m['author_flair_text'], '$f.author_flair_text'),
      awardIcons: parseAwardIcons(m['all_awardings'], '$f.all_awardings'),
      created: parseTime(m['created'], '$f.created'),
      createdUtc: parseTimeUtc(m['created_utc'], '$f.created_utc'),
      domain: parseString(m['domain'], '$f.domain'),
      downs: parseInt(m['downs'], '$f.downs'),
      // edited: parseInt(m['edited'], '$f.edited'),
      hidden: parseBool(m['hidden'], '$f.hidden'),
      id: parseString(m['id'], '$f.id'),
      isVideo: parseBool(m['is_video'], '$f.is_video'),
      linkFlairText: parseString(m['link_flair_text'], '$f.link_flair_text'),
      totalAwardsReceived: parseInt(m['total_awards_received'], '$f.total_awards_received'),
      numComments: parseInt(m['num_comments'], '$f.num_comments'),
      over18: parseBool(m['over_18'], '$f.over_18'),
      pinned: parseBool(m['pinned'], '$f.pinned'),
      score: parseInt(m['score'], '$f.score'),
      selftext: parseString(m['selftext'], '$f.selftext'),
      subreddit: parseString(m['subreddit'], '$f.subreddit'),
      subredditNamePrefixed: parseString(m['subreddit_name_prefixed'], '$f.subreddit_name_prefixed'),
      thumbnail: parseUrl(m['thumbnail'], '$f.thumbnail'),
      title: parseString(m['title'], '$f.title'),
      ups: parseInt(m['ups'], '$f.ups'),
      url: parseUrl(m['url'], '$f.url'),
      likes: parseLikes(m['likes'], '$f.likes'),
      saved: parseBool(m['saved'], '$f.saved'),
      // shortLink: _genShortLink(mapGet(m, 'id', '')),
      // type: type,
      // preview: parsePreview(m['preview'], '$f.preview'),
      preview: parsePreview(m['preview'], '$f.preview'),
      video: parseVideo(m['media'], '$f.media'),
      postHint: parsePostHint(m['post_hint'], m['url'], '$f.post_hint'),
      comments: comments,
    );
  }

  // static final _log = getLogger('Submission');

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
      ups,
      url,
      awardIcons,
      totalAwardsReceived,
      likes,
      // type,
      comments,
      saved,
      shortLink,
      preview,
      video,
      postHint,
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
    Likes? likes,
    bool? saved,
    SubType? type,
    List<Comment>? comments,
    List<Preview>? preview,
    Video? Function()? video,
    PostHint? postHint,
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
      // type: type ?? this.type,
      comments: comments ?? this.comments,
      preview: preview ?? this.preview,
      // video: video != null ? video.value : this.video,
      video: video != null ? video() : this.video,
      postHint: postHint ?? this.postHint,
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
