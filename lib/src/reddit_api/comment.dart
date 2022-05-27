import 'package:draw/draw.dart' as draw;
import 'package:equatable/equatable.dart';

import 'call.dart';
import 'like.dart';
import 'parse.dart';

class Comment extends Equatable {
  const Comment({
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
    this.drawComment,
  });

  factory Comment.fromJson(Map<String, dynamic> m,
      {draw.Comment? drawComment}) {
    const f = 'comment';
    return Comment(
      subredditId: parseString(m['subreddit_id'], '$f.subreddit_id'),
      authorIsBlocked:
          parseBool(m['author_is_blocked'], '$f.author_is_blocked'),
      commentType: parseString(m['comment_type'], '$f.comment_type'),
      linkTitle: parseString(m['link_title'], '$f.link_title'),
      ups: parseInt(m['ups'], '$f.ups'),
      authorFlairType:
          parseString(m['author_flair_type'], '$f.author_flair_type'),
      totalAwardsReceived:
          parseInt(m['total_awards_received'], '$f.total_awards_received'),
      subreddit: parseString(m['subreddit'], '$f.subreddit'),
      linkAuthor: parseString(m['link_author'], '$f.link_author'),
      likes: parseLikes(m['likes'], '$f.likes'),
      replies: parseReplies(m['replies'], '$f.replies'),
      saved: parseBool(m['saved'], '$f.saved'),
      id: parseString(m['id'], '$f.id'),
      gilded: parseInt(m['gilded'], '$f.gilded'),
      archived: parseBool(m['archived'], '$f.archived'),
      noFollow: parseBool(m['no_follow'], '$f.no_follow'),
      author: parseString(m['author'], '$f.author'),
      numComments: parseInt(m['num_comments'], '$f.num_comments'),
      sendReplies: parseBool(m['send_replies'], '$f.send_replies'),
      parentId: parseString(m['parent_id'], '$f.parent_id'),
      score: parseInt(m['score'], '$f.score'),
      authorFullname: parseString(m['author_fullname'], '$f.author_fullname'),
      over18: parseBool(m['over_18'], '$f.over_18'),
      controversiality: parseInt(m['controversiality'], '$f.controversiality'),
      body: parseBody(m['body'], '$f.body'),
      downs: parseInt(m['downs'], '$f.downs'),
      isSubmitter: parseBool(m['is_submitter'], '$f.is_submitter'),
      collapsed: parseBool(m['collapsed'], '$f.collapsed'),
      bodyHtml: parseString(m['body_html'], '$f.body_html'),
      distinguished: parseBool(m['distinguished'], '$f.distinguished'),
      stickied: parseBool(m['stickied'], '$f.stickied'),
      authorPremium: parseBool(m['author_premium'], '$f.author_premium'),
      linkId: parseString(m['link_id'], '$f.link_id'),
      permalink: parseString(m['permalink'], '$f.permalink'),
      subredditType: parseString(m['subreddit_type'], '$f.subreddit_type'),
      linkPermalink: parseUrl(m['link_permalink'], '$f.link_permalink'),
      name: parseString(m['name'], '$f.name'),
      subredditNamePrefixed: parseString(
          m['subreddit_name_prefixed'], '$f.subreddit_name_prefixed'),
      treatmentTags: parseListString(m['treatment_tags'], '$f.treatment_tags'),
      created: parseTime(m['created'], '$f.created'),
      createdUtc: parseTimeUtc(m['created_utc'], '$f.created_utc'),
      locked: parseBool(m['locked'], '$f.locked'),
      quarantine: parseBool(m['quarantine'], '$f.quarantine'),
      linkUrl: parseUrl(m['link_url'], '$f.link_url'),
      submissionId: parseSubmissionId(m['link_id'], '$f.link_id'),
      awardIcons: parseAwardIcons(m['all_awardings'], '$f.all_awardings'),
      drawComment: drawComment,
    );
  }

  final String subredditId;
  final bool authorIsBlocked;
  final String commentType;
  final String linkTitle;
  final int ups;
  final String authorFlairType;
  final int totalAwardsReceived;
  final String subreddit;
  final String linkAuthor;
  final Like likes;
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
  final draw.Comment? drawComment;

  String get shortLink => submissionId == '' || id == ''
      ? ''
      : 'https://www.reddit.com/comments/$submissionId/_/$id';

  @override
  List<Object?> get props {
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
      drawComment,
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
    Like? likes,
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
    draw.Comment? Function()? drawComment,
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
      drawComment: tryCall(drawComment) ?? this.drawComment,
    );
  }
}
