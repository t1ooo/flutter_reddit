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

  factory User.fromJson(Map data) {
    return User(
      isEmployee: mapGet(data, 'is_employee', false, _log),
      isFriend: mapGet(data, 'is_friend', false, _log),
      awardeeKarma: mapGet(data, 'awardee_karma', 0, _log),
      id: mapGet(data, 'id', '', _log),
      verified: mapGet(data, 'verified', false, _log),
      isGold: mapGet(data, 'is_gold', false, _log),
      isMod: mapGet(data, 'is_mod', false, _log),
      awarderKarma: mapGet(data, 'awarder_karma', 0, _log),
      hasVerifiedEmail: mapGet(data, 'has_verified_email', false, _log),
      iconImg: parseUrl(data['icon_img'], _log),
      linkKarma: mapGet(data, 'link_karma', 0, _log),
      isBlocked: mapGet(data, 'is_blocked', false, _log),
      totalKarma: mapGet(data, 'total_karma', 0, _log),
      acceptChats: mapGet(data, 'accept_chats', false, _log),
      name: mapGet(data, 'name', '', _log),
      // displayNamePrefixed: mapGetNested(data, ['subreddit','display_name_prefixed'], '', _log),
      created: parseTime(data['created'], false, _log),
      createdUtc: parseTime(data['created_utc'], true, _log),
      snoovatarImg: mapGet(data, 'snoovatar_img', '', _log),
      commentKarma: mapGet(data, 'comment_karma', 0, _log),
      acceptFollowers: mapGet(data, 'accept_followers', false, _log),
      hasSubscribed: mapGet(data, 'has_subscribed', false, _log),
      subreddit: Subreddit.fromJson(cast(data['subreddit'], {})),
    );
  }

  static final _log = getLogger('User');

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
