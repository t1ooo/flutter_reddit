import 'package:draw/draw.dart' as draw;
import 'package:equatable/equatable.dart';

import 'package:flutter_reddit_prototype/src/reddit_api/submission_type.dart';
import '../util/map.dart';
import 'parse.dart';

// TODO: gen from json
// TODO: awards 'total_awards_received'
// TODO: subreddit icon
class Submission extends Equatable {
  Submission({
    required this.author,
    required this.createdUtc,
    required this.domain,
    required this.downvotes,
    required this.edited,
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
    required this.numAwards,
    required this.type,
  });

  final String author;
  final DateTime createdUtc;
  final String domain;
  final int downvotes;
  final bool edited;
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
  final Uri url;
  final List<String> awardIcons;
  final int numAwards;
  final SubType type;

  // static final _log = Logger('Submission');

  static const _descLen = 200;
  String get desc {
    final text = selftext.replaceAll(RegExp(r'\s+'), ' ');
    // return selftext.length <= _descLen ? selftext : selftext.substring(0, _descLen);
    return text.length <= _descLen ? text : text.substring(0, _descLen) + '...';
  }

  factory Submission.fromDrawSubmission(draw.Submission sub, {required SubType type}) {
    final data = sub.data!;

    return Submission(
      author: sub.author,
      authorFlairText: sub.authorFlairText ?? '',
      awardIcons: parseAwardIcons(data['all_awardings']),
      createdUtc: sub.createdUtc,
      domain: sub.domain,
      downvotes: sub.downvotes,
      edited: sub.edited,
      hidden: sub.hidden,
      id: sub.id ?? '',
      isVideo: sub.isVideo,
      linkFlairText: sub.linkFlairText ?? '',
      numAwards: mapGet(data, 'total_awards_received', 0),
      numComments: sub.numComments,
      over18: sub.over18,
      pinned: sub.pinned,
      score: sub.score,
      selftext: sub.selftext ?? '',
      subreddit: sub.subreddit.displayName,
      subredditNamePrefixed: mapGet(data, 'subreddit_name_prefixed', ''),
      thumbnail: parseUri(data['thumbnail']),
      title: sub.title,
      upvotes: sub.upvotes,
      url: sub.url,
      type: type,
    );
  }

  // static String _parseThumbnail(dynamic thumbnail) {
  //   try {
  //     return thumbnail.startsWith('http') ? thumbnail : '';
  //   } on Exception catch (e) {
  //     _log.warning(e);
  //     return '';
  //   }
  // }

  // static List<String> _parseAwardIcons(dynamic allAwardings) {
  //   try {
  //     return (allAwardings as List<dynamic>)
  //         .map((v) {
  //           return v['resized_icons'][0]['url'];
  //         })
  //         .where((v) {
  //           return (v is String) && v.contains('redditstatic.com');
  //         })
  //         .map((v) => v as String)
  //         .toList();
  //   } on Exception catch (e) {
  //     _log.warning(e);
  //     return [];
  //   }
  // }

  @override
  List<Object> get props {
    return [
      author,
      createdUtc,
      domain,
      downvotes,
      edited,
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
      numAwards,
      type,
    ];
  }
}

Submission placeholderSubmission() {
  return Submission(
    author: 'author',
    createdUtc: DateTime.now(),
    domain: 'domain',
    downvotes: 0,
    edited: true,
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
    url: Uri.parse('https://example.com'),
    awardIcons: [],
    numAwards: 0,
    type: SubType.best,
  );
}
