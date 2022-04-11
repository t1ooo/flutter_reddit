import 'package:equatable/equatable.dart';

import 'package:flutter_reddit_prototype/src/reddit_api/parse.dart';

import '../util/map.dart';

class Comment extends Equatable {
  Comment({
    required this.subredditId,
    required this.authorIsBlocked,
    required this.commentType,
    required this.linkTitle,
    required this.ups,
    required this.authorFlairType,
    required this.totalAwardsReceived,
    required this.subreddit,
    required this.linkAuthor,
    required this.likes,
    required this.replies,
    required this.saved,
    required this.id,
    required this.gilded,
    required this.archived,
    required this.noFollow,
    required this.author,
    required this.numComments,
    required this.sendReplies,
    required this.parentId,
    required this.score,
    required this.authorFullname,
    required this.over18,
    required this.controversiality,
    required this.body,
    // required this.edited,
    required this.downs,
    required this.isSubmitter,
    required this.collapsed,
    required this.bodyHtml,
    required this.distinguished,
    required this.stickied,
    required this.authorPremium,
    required this.linkId,
    required this.permalink,
    required this.subredditType,
    required this.linkPermalink,
    required this.name,
    required this.subredditNamePrefixed,
    required this.treatmentTags,
    required this.created,
    required this.createdUtc,
    required this.locked,
    required this.quarantine,
    required this.linkUrl,
    required this.submissionId,
  });

  final String subredditId;
  final bool authorIsBlocked;
  final String commentType;
  final String linkTitle;
  final int ups;
  final String authorFlairType;
  final int totalAwardsReceived;
  final String subreddit;
  final String linkAuthor;
  final int likes;
  final String replies;
  final bool saved;
  final String id;
  final int gilded;
  final bool archived;
  final bool noFollow;
  final String author;
  final int numComments;
  final bool sendReplies;
  final String parentId;
  final int score;
  final String authorFullname;
  final bool over18;
  final int controversiality;
  final String body;
  // final double edited;
  final int downs;
  final bool isSubmitter;
  final bool collapsed;
  final String bodyHtml;
  final bool distinguished;
  final bool stickied;
  final bool authorPremium;
  final String linkId;
  final String permalink;
  final String subredditType;
  final String linkPermalink;
  final String name;
  final String subredditNamePrefixed;
  final List<String> treatmentTags;
  final DateTime created;
  final DateTime createdUtc;
  final bool locked;
  final bool quarantine;
  final String linkUrl;
  final String submissionId;

  // static final _log = Logger('Comment');

  // String get submissionId => linkId.split('_').last;

  factory Comment.fromMap(Map data) {
    return Comment(
      subredditId: mapGet(data, 'subreddit_id', ''),
      authorIsBlocked: mapGet(data, 'author_is_blocked', false),
      commentType: mapGet(data, 'comment_type', ''),
      linkTitle: mapGet(data, 'link_title', ''),
      ups: mapGet(data, 'ups', 0),
      authorFlairType: mapGet(data, 'author_flair_type', ''),
      totalAwardsReceived: mapGet(data, 'total_awards_received', 0),
      subreddit: mapGet(data, 'subreddit', ''),
      linkAuthor: mapGet(data, 'link_author', ''),
      likes: mapGet(data, 'likes', 0),
      replies: mapGet(data, 'replies', ''),
      saved: mapGet(data, 'saved', false),
      id: mapGet(data, 'id', ''),
      gilded: mapGet(data, 'gilded', 0),
      archived: mapGet(data, 'archived', false),
      noFollow: mapGet(data, 'no_follow', false),
      author: mapGet(data, 'author', ''),
      numComments: mapGet(data, 'num_comments', 0),
      sendReplies: mapGet(data, 'send_replies', false),
      parentId: mapGet(data, 'parent_id', ''),
      score: mapGet(data, 'score', 0),
      authorFullname: mapGet(data, 'author_fullname', ''),
      over18: mapGet(data, 'over_18', false),
      controversiality: mapGet(data, 'controversiality', 0),
      body: mapGet(data, 'body', ''),
      // edited: mapGet(data, 'edited', 0),
      downs: mapGet(data, 'downs', 0),
      isSubmitter: mapGet(data, 'is_submitter', false),
      collapsed: mapGet(data, 'collapsed', false),
      bodyHtml: mapGet(data, 'body_html', ''),
      distinguished: mapGet(data, 'distinguished', false),
      stickied: mapGet(data, 'stickied', false),
      authorPremium: mapGet(data, 'author_premium', false),
      linkId: mapGet(data, 'link_id', ''),
      permalink: mapGet(data, 'permalink', ''),
      subredditType: mapGet(data, 'subreddit_type', ''),
      // linkPermalink: mapGet(data, 'link_permalink', ''),
      linkPermalink: parseUri(data['link_permalink']),
      name: mapGet(data, 'name', ''),
      subredditNamePrefixed: mapGet(data, 'subreddit_name_prefixed', ''),
      treatmentTags: mapGetList(data, 'treatment_tags', []),
      created: parseTime(data['created']),
      createdUtc: parseTime(data['created_utc'], isUtc: true),
      locked: mapGet(data, 'locked', false),
      quarantine: mapGet(data, 'quarantine', false),
      // linkUrl: mapGet(data, 'link_url', ''),
      linkUrl: parseUri(data['link_url']),
      submissionId: mapGet(data, 'link_id', '').split('_').last,
    );
  }

  @override
  List<Object> get props {
    return [
      subredditId,
      authorIsBlocked,
      commentType,
      linkTitle,
      ups,
      authorFlairType,
      totalAwardsReceived,
      subreddit,
      linkAuthor,
      likes,
      replies,
      saved,
      id,
      gilded,
      archived,
      noFollow,
      author,
      numComments,
      sendReplies,
      parentId,
      score,
      authorFullname,
      over18,
      controversiality,
      body,
      // edited,
      downs,
      isSubmitter,
      collapsed,
      bodyHtml,
      distinguished,
      stickied,
      authorPremium,
      linkId,
      permalink,
      subredditType,
      linkPermalink,
      name,
      subredditNamePrefixed,
      treatmentTags,
      created,
      createdUtc,
      locked,
      quarantine,
      linkUrl,
      submissionId,
    ];
  }
}
