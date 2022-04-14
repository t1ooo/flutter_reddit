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
  });

  final String author;
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

  // static final _log = Logger('Submission');

  static const _descLen = 200;
  String get desc {
    final text = selftext.replaceAll(RegExp(r'\s+'), ' ');
    // return selftext.length <= _descLen ? selftext : selftext.substring(0, _descLen);
    return text.length <= _descLen ? text : text.substring(0, _descLen) + '...';
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
      thumbnail: parseUri(data['thumbnail']),
      title: mapGet(data, 'title', ''),
      upvotes: mapGet(data, 'ups', 0),
      url: parseUri(data['url']),
      likes: parseLikes(data['likes']),
      saved: mapGet(data, 'saved', false),
      type: type,
      comments: comments,
    );
  }

  @override
  List<Object?> get props {
    return [
      author,
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
    ];
  }
}

Submission placeholderSubmission() {
  return Submission(
    author: 'author',
    createdUtc: DateTime.now(),
    domain: 'domain',
    downs: 0,
    // edited: 0,
    hidden: false,
    id: 'id',
    isVideo: false,
    linkFlairText: 'linkFlairText',
    authorFlairText: 'authorFlairText',
    numComments: 0,
    over18: false,
    pinned: true,
    score: 0,
    selftext: 'selftext',
    subreddit: 'subreddit',
    subredditNamePrefixed: 'subredditNamePrefixed',
    thumbnail: 'thumbnail',
    title: 'title',
    upvotes: 0,
    url: 'https://example.com',
    awardIcons: [],
    totalAwardsReceived: 0,
    likes: Vote.none,
    type: SubType.best,
    comments: [],
    saved:false,
  );
}
