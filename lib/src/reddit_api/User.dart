import 'package:equatable/equatable.dart';

import 'package:flutter_reddit_prototype/src/reddit_api/parse.dart';

import '../util/map.dart';

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
    required this.created,
    required this.createdUtc,
    required this.snoovatarImg,
    required this.commentKarma,
    required this.acceptFollowers,
    required this.hasSubscribed,
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
  final DateTime created;
  final DateTime createdUtc;
  final String snoovatarImg;
  final int commentKarma;
  final bool acceptFollowers;
  final bool hasSubscribed;

  factory User.fromMap(Map data) {
    return User(
      isEmployee: mapGet(data, 'is_employee', false),
      isFriend: mapGet(data, 'is_friend', false),
      awardeeKarma: mapGet(data, 'awardee_karma', 0),
      id: mapGet(data, 'id', ''),
      verified: mapGet(data, 'verified', false),
      isGold: mapGet(data, 'is_gold', false),
      isMod: mapGet(data, 'is_mod', false),
      awarderKarma: mapGet(data, 'awarder_karma', 0),
      hasVerifiedEmail: mapGet(data, 'has_verified_email', false),
      iconImg: mapGet(data, 'icon_img', ''),
      linkKarma: mapGet(data, 'link_karma', 0),
      isBlocked: mapGet(data, 'is_blocked', false),
      totalKarma: mapGet(data, 'total_karma', 0),
      acceptChats: mapGet(data, 'accept_chats', false),
      name: mapGet(data, 'name', ''),
      created: parseTime(data['created']),
      createdUtc: parseTime(data['created_utc'], isUtc: true),
      snoovatarImg: mapGet(data, 'snoovatar_img', ''),
      commentKarma: mapGet(data, 'comment_karma', 0),
      acceptFollowers: mapGet(data, 'accept_followers', false),
      hasSubscribed: mapGet(data, 'has_subscribed', false),
    );
  }

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
      created,
      createdUtc,
      snoovatarImg,
      commentKarma,
      acceptFollowers,
      hasSubscribed,
    ];
  }
}
