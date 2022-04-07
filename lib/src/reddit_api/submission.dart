import 'package:draw/draw.dart' as draw;
import 'package:equatable/equatable.dart';

// TODO: awards
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

  static const _descLen = 200;
  String get desc {
    final text = selftext.replaceAll(RegExp(r'\s+'), ' ');
    // return selftext.length <= _descLen ? selftext : selftext.substring(0, _descLen);
    return text.length <= _descLen ? text : text.substring(0, _descLen) + '...';
  }

  factory Submission.fromDrawSubmission(draw.Submission sub) {
    final data = sub.data!;
    return Submission(
      author: sub.author,
      createdUtc: sub.createdUtc,
      domain: sub.domain,
      downvotes: sub.downvotes,
      edited: sub.edited,
      hidden: sub.hidden,
      id: sub.id ?? '',
      isVideo: sub.isVideo,
      linkFlairText: sub.linkFlairText ?? '',
      authorFlairText: sub.authorFlairText ?? '',
      numComments: sub.numComments,
      over18: sub.over18,
      pinned: sub.pinned,
      score: sub.score,
      selftext: sub.selftext ?? '',
      // thumbnail: (sub.thumbnail.toString() == 'self') ? '' : sub.thumbnail.toString(),
      thumbnail:
          (data['thumbnail'].startsWith('http')) ? data['thumbnail'] : '',
      title: sub.title,
      upvotes: sub.upvotes,
      url: sub.url,
      subreddit: sub.subreddit.displayName,
      subredditNamePrefixed: data['subreddit_name_prefixed'],
    );
  }

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
    ];
  }
}
