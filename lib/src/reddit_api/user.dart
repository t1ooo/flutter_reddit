import 'package:equatable/equatable.dart';

import '../logging/logging.dart';
import 'subreddit.dart';
import 'parse.dart';

class User extends Equatable {
  User({
    required this.isEmployee,
    required this.isFriend,
    required this.awardeeKarma,
    required this.id,
    required this.verified,
    required this.isGold,
    required this.isMod,
    required this.awarderKarma,
    required this.hasVerifiedEmail,
    required this.iconImg,
    required this.linkKarma,
    required this.isBlocked,
    required this.totalKarma,
    required this.acceptChats,
    required this.name,
    // required this.displayNamePrefixed,
    required this.created,
    required this.createdUtc,
    required this.snoovatarImg,
    required this.commentKarma,
    required this.acceptFollowers,
    required this.hasSubscribed,
    required this.subreddit,
  });

  final bool isEmployee;
  final bool isFriend;
  final int awardeeKarma;
  final String id;
  final bool verified;
  final bool isGold;
  final bool isMod;
  final int awarderKarma;
  final bool hasVerifiedEmail;
  final String iconImg;
  final int linkKarma;
  final bool isBlocked;
  final int totalKarma;
  final bool acceptChats;
  final String name;
  // final String displayNamePrefixed;
  final DateTime created;
  final DateTime createdUtc;
  final String snoovatarImg;
  final int commentKarma;
  final bool acceptFollowers;
  final bool hasSubscribed;
  final Subreddit subreddit;

  factory User.fromJson(Map<String, dynamic> m) {
    const f = 'User';
    return User(
      isEmployee: parseBool(m['is_employee'], '$f.is_employee'),
      isFriend: parseBool(m['is_friend'], '$f.is_friend'),
      awardeeKarma: parseInt(m['awardee_karma'], '$f.awardee_karma'),
      id: parseString(m['id'], '$f.id'),
      verified: parseBool(m['verified'], '$f.verified'),
      isGold: parseBool(m['is_gold'], '$f.is_gold'),
      isMod: parseBool(m['is_mod'], '$f.is_mod'),
      awarderKarma: parseInt(m['awarder_karma'], '$f.awarder_karma'),
      hasVerifiedEmail: parseBool(m['has_verified_email'], '$f.has_verified_email'),
      iconImg: parseUrl(m['icon_img'], '$f.icon_img'),
      linkKarma: parseInt(m['link_karma'], '$f.link_karma'),
      isBlocked: parseBool(m['is_blocked'], '$f.is_blocked'),
      totalKarma: parseInt(m['total_karma'], '$f.total_karma'),
      acceptChats: parseBool(m['accept_chats'], '$f.accept_chats'),
      name: parseString(m['name'], '$f.name'),
      // displayNamePrefixed: mapGetNested(m, ['subreddit','display_name_prefixed'], '', _log),
      created: parseTime(m['created'], '$f.created'),
      createdUtc: parseTimeUtc(m['created_utc'], '$f.created_utc'),
      snoovatarImg: parseString(m['snoovatar_img'], '$f.snoovatar_img'),
      commentKarma: parseInt(m['comment_karma'], '$f.comment_karma'),
      acceptFollowers: parseBool(m['accept_followers'], '$f.accept_followers'),
      hasSubscribed: parseBool(m['has_subscribed'], '$f.has_subscribed'),
      subreddit: Subreddit.fromJson(cast(m['subreddit'], {}, '$f.subreddit')),
    );
  }

  // static final _log = getLogger('User');

  @override
  List<Object> get props {
    return [
      isEmployee,
      isFriend,
      awardeeKarma,
      id,
      verified,
      isGold,
      isMod,
      awarderKarma,
      hasVerifiedEmail,
      iconImg,
      linkKarma,
      isBlocked,
      totalKarma,
      acceptChats,
      name,
      // displayNamePrefixed,
      created,
      createdUtc,
      snoovatarImg,
      commentKarma,
      acceptFollowers,
      hasSubscribed,
      subreddit,
    ];
  }
}
