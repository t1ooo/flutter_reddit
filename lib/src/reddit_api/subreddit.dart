import 'package:draw/draw.dart' as draw;
import 'package:equatable/equatable.dart';

import 'call.dart';

class Subreddit extends Equatable {
  const Subreddit({
    required this.communityIcon,
    required this.created,
    required this.createdUtc,
    required this.description,
    required this.descriptionHtml,
    required this.displayName,
    required this.displayNamePrefixed,
    required this.id,
    required this.lang,
    required this.name,
    required this.publicDescription,
    required this.publicDescriptionHtml,
    required this.submitTextHtml,
    required this.submitText,
    required this.subredditType,
    required this.subscribers,
    required this.title,
    required this.url,
    required this.headerImg,
    required this.bannerBackgroundImage,
    required this.bannerBackgroundColor,
    required this.userIsSubscriber,
    required this.userHasFavorited,
    required this.drawSubreddit,
  });

  final String communityIcon;
  final DateTime created;
  final DateTime createdUtc;
  final String description;
  final String descriptionHtml;
  final String displayName;
  final String displayNamePrefixed;
  final String id;
  final String lang;
  final String name;
  final String publicDescription;
  final String publicDescriptionHtml;
  final String submitTextHtml;
  final String submitText;
  final String subredditType;
  final int subscribers;
  final String title;
  final String url;
  final String headerImg;
  final String bannerBackgroundImage;
  final String bannerBackgroundColor;
  final bool userIsSubscriber;
  final bool userHasFavorited;
  final draw.Subreddit? drawSubreddit;

  String get shortLink {
    return 'https://www.reddit.com/$displayNamePrefixed';
  }

  Subreddit copyWith({
    String? communityIcon,
    DateTime? created,
    DateTime? createdUtc,
    String? description,
    String? descriptionHtml,
    String? displayName,
    String? displayNamePrefixed,
    String? id,
    String? lang,
    String? name,
    String? publicDescription,
    String? publicDescriptionHtml,
    String? submitTextHtml,
    String? submitText,
    String? subredditType,
    int? subscribers,
    String? title,
    String? url,
    String? headerImg,
    String? bannerBackgroundImage,
    String? bannerBackgroundColor,
    bool? userIsSubscriber,
    bool? userHasFavorited,
    draw.Subreddit? Function()? drawSubreddit,
  }) {
    return Subreddit(
      communityIcon: communityIcon ?? this.communityIcon,
      created: created ?? this.created,
      createdUtc: createdUtc ?? this.createdUtc,
      description: description ?? this.description,
      descriptionHtml: descriptionHtml ?? this.descriptionHtml,
      displayName: displayName ?? this.displayName,
      displayNamePrefixed: displayNamePrefixed ?? this.displayNamePrefixed,
      id: id ?? this.id,
      lang: lang ?? this.lang,
      name: name ?? this.name,
      publicDescription: publicDescription ?? this.publicDescription,
      publicDescriptionHtml:
          publicDescriptionHtml ?? this.publicDescriptionHtml,
      submitTextHtml: submitTextHtml ?? this.submitTextHtml,
      submitText: submitText ?? this.submitText,
      subredditType: subredditType ?? this.subredditType,
      subscribers: subscribers ?? this.subscribers,
      title: title ?? this.title,
      url: url ?? this.url,
      headerImg: headerImg ?? this.headerImg,
      bannerBackgroundImage:
          bannerBackgroundImage ?? this.bannerBackgroundImage,
      bannerBackgroundColor:
          bannerBackgroundColor ?? this.bannerBackgroundColor,
      userIsSubscriber: userIsSubscriber ?? this.userIsSubscriber,
      userHasFavorited: userHasFavorited ?? this.userHasFavorited,
      drawSubreddit: tryCall(drawSubreddit) ?? this.drawSubreddit,
    );
  }

  @override
  List<Object?> get props {
    return [
      communityIcon,
      created,
      createdUtc,
      description,
      descriptionHtml,
      displayName,
      displayNamePrefixed,
      id,
      lang,
      name,
      publicDescription,
      publicDescriptionHtml,
      submitTextHtml,
      submitText,
      subredditType,
      subscribers,
      title,
      url,
      headerImg,
      bannerBackgroundImage,
      bannerBackgroundColor,
      userIsSubscriber,
      userHasFavorited,
      drawSubreddit,
    ];
  }
}

String removeSubredditPrefix(String name) {
  const prefix = 'r/';
  if (name.startsWith(prefix)) {
    return name.substring(prefix.length);
  }
  return name;
}
