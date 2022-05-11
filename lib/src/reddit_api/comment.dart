import 'package:equatable/equatable.dart';

import '../logging/logging.dart';
import 'parse.dart';
import 'vote.dart';

// class Comment extends Equatable {
class Comment {
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
    required this.awardIcons,
  });

  factory Comment.fromJson(Map data) {
    return Comment(
      subredditId: mapGet(data, 'subreddit_id', '', _log),
      authorIsBlocked: mapGet(data, 'author_is_blocked', false, _log),
      commentType: mapGet(data, 'comment_type', '', _log),
      linkTitle: mapGet(data, 'link_title', '', _log),
      ups: mapGet(data, 'ups', 0, _log),
      authorFlairType: mapGet(data, 'author_flair_type', '', _log),
      totalAwardsReceived: mapGet(data, 'total_awards_received', 0, _log),
      subreddit: mapGet(data, 'subreddit', '', _log),
      linkAuthor: mapGet(data, 'link_author', '', _log),
      likes: parseLikes(data['likes'], _log),
      replies: parseCommentReplies(data['replies']?['data']['children'], _log),
      saved: mapGet(data, 'saved', false, _log),
      id: mapGet(data, 'id', '', _log),
      gilded: mapGet(data, 'gilded', 0, _log),
      archived: mapGet(data, 'archived', false, _log),
      noFollow: mapGet(data, 'no_follow', false, _log),
      author: mapGet(data, 'author', '', _log),
      numComments: mapGet(data, 'num_comments', 0, _log),
      sendReplies: mapGet(data, 'send_replies', false, _log),
      parentId: mapGet(data, 'parent_id', '', _log),
      score: mapGet(data, 'score', 0, _log),
      authorFullname: mapGet(data, 'author_fullname', '', _log),
      over18: mapGet(data, 'over_18', false, _log),
      controversiality: mapGet(data, 'controversiality', 0, _log),
      body: parseText(data['body']),
      downs: mapGet(data, 'downs', 0, _log),
      isSubmitter: mapGet(data, 'is_submitter', false, _log),
      collapsed: mapGet(data, 'collapsed', false, _log),
      bodyHtml: mapGet(data, 'body_html', '', _log),
      distinguished: mapGet(data, 'distinguished', false, _log),
      stickied: mapGet(data, 'stickied', false, _log),
      authorPremium: mapGet(data, 'author_premium', false, _log),
      linkId: mapGet(data, 'link_id', '', _log),
      permalink: mapGet(data, 'permalink', '', _log),
      subredditType: mapGet(data, 'subreddit_type', '', _log),
      linkPermalink: parseUrl(data['link_permalink'], _log),
      name: mapGet(data, 'name', '', _log),
      subredditNamePrefixed: mapGet(data, 'subreddit_name_prefixed', '', _log),
      treatmentTags: mapGetList(data, 'treatment_tags', [], _log),
      created: parseTime(data['created'], false, _log),
      createdUtc: parseTime(data['created_utc'], true, _log),
      locked: mapGet(data, 'locked', false, _log),
      quarantine: mapGet(data, 'quarantine', false, _log),
      linkUrl: parseUrl(data['link_url'], _log),
      submissionId: mapGet(data, 'link_id', '', _log).split('_').last,
      awardIcons: parseAwardIcons(data['all_awardings'], _log),
    );
  }

  static final _log = getLogger('Comment');

  final String subredditId;
  final bool authorIsBlocked;
  final String commentType;
  final String linkTitle;
  final int ups;
  final String authorFlairType;
  final int totalAwardsReceived;
  final String subreddit;
  final String linkAuthor;
  final Vote likes;
  final List<Comment> replies;
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
  final List<String> awardIcons;

  String get shortLink {
    if (submissionId == '' || id == '') {
      return '';
    }
    return 'https://www.reddit.com/comments/$submissionId/_/$id';
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
      awardIcons,
    ];
  }

  Comment copyWith({
    String? subredditId,
    bool? authorIsBlocked,
    String? commentType,
    String? linkTitle,
    int? ups,
    String? authorFlairType,
    int? totalAwardsReceived,
    String? subreddit,
    String? linkAuthor,
    Vote? likes,
    List<Comment>? replies,
    bool? saved,
    String? id,
    int? gilded,
    bool? archived,
    bool? noFollow,
    String? author,
    int? numComments,
    bool? sendReplies,
    String? parentId,
    int? score,
    String? authorFullname,
    bool? over18,
    int? controversiality,
    String? body,
    int? downs,
    bool? isSubmitter,
    bool? collapsed,
    String? bodyHtml,
    bool? distinguished,
    bool? stickied,
    bool? authorPremium,
    String? linkId,
    String? permalink,
    String? subredditType,
    String? linkPermalink,
    String? name,
    String? subredditNamePrefixed,
    List<String>? treatmentTags,
    DateTime? created,
    DateTime? createdUtc,
    bool? locked,
    bool? quarantine,
    String? linkUrl,
    String? submissionId,
    List<String>? awardIcons,
  }) {
    return Comment(
      subredditId: subredditId ?? this.subredditId,
      authorIsBlocked: authorIsBlocked ?? this.authorIsBlocked,
      commentType: commentType ?? this.commentType,
      linkTitle: linkTitle ?? this.linkTitle,
      ups: ups ?? this.ups,
      authorFlairType: authorFlairType ?? this.authorFlairType,
      totalAwardsReceived: totalAwardsReceived ?? this.totalAwardsReceived,
      subreddit: subreddit ?? this.subreddit,
      linkAuthor: linkAuthor ?? this.linkAuthor,
      likes: likes ?? this.likes,
      replies: replies ?? this.replies,
      saved: saved ?? this.saved,
      id: id ?? this.id,
      gilded: gilded ?? this.gilded,
      archived: archived ?? this.archived,
      noFollow: noFollow ?? this.noFollow,
      author: author ?? this.author,
      numComments: numComments ?? this.numComments,
      sendReplies: sendReplies ?? this.sendReplies,
      parentId: parentId ?? this.parentId,
      score: score ?? this.score,
      authorFullname: authorFullname ?? this.authorFullname,
      over18: over18 ?? this.over18,
      controversiality: controversiality ?? this.controversiality,
      body: body ?? this.body,
      downs: downs ?? this.downs,
      isSubmitter: isSubmitter ?? this.isSubmitter,
      collapsed: collapsed ?? this.collapsed,
      bodyHtml: bodyHtml ?? this.bodyHtml,
      distinguished: distinguished ?? this.distinguished,
      stickied: stickied ?? this.stickied,
      authorPremium: authorPremium ?? this.authorPremium,
      linkId: linkId ?? this.linkId,
      permalink: permalink ?? this.permalink,
      subredditType: subredditType ?? this.subredditType,
      linkPermalink: linkPermalink ?? this.linkPermalink,
      name: name ?? this.name,
      subredditNamePrefixed:
          subredditNamePrefixed ?? this.subredditNamePrefixed,
      treatmentTags: treatmentTags ?? this.treatmentTags,
      created: created ?? this.created,
      createdUtc: createdUtc ?? this.createdUtc,
      locked: locked ?? this.locked,
      quarantine: quarantine ?? this.quarantine,
      linkUrl: linkUrl ?? this.linkUrl,
      submissionId: submissionId ?? this.submissionId,
      awardIcons: awardIcons ?? this.awardIcons,
    );
  }
}
