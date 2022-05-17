import 'package:equatable/equatable.dart';

import 'parse.dart';

class Subreddit extends Equatable {
  Subreddit({
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

  factory Subreddit.fromJson(Map<String, dynamic> m) {
    const f = 'Subreddit';
    return Subreddit(
      communityIcon: parseUrl(m['community_icon'], '$f.community_icon'),
      created: parseTime(m['created'], '$f.created'),
      createdUtc: parseTimeUtc(m['created_utc'], '$f.created_utc'),
      description: parseString(m['description'], '$f.description'),
      descriptionHtml:
          parseString(m['description_html'], '$f.description_html'),
      displayName: parseString(m['display_name'], '$f.display_name'),
      displayNamePrefixed:
          parseString(m['display_name_prefixed'], '$f.display_name_prefixed'),
      id: parseString(m['id'], '$f.id'),
      lang: parseString(m['lang'], '$f.lang'),
      name: parseString(m['name'], '$f.name'),
      publicDescription:
          parseString(m['public_description'], '$f.public_description'),
      publicDescriptionHtml: parseString(
          m['public_description_html'], '$f.public_description_html'),
      submitTextHtml: parseString(m['submit_text_html'], '$f.submit_text_html'),
      submitText: parseString(m['submit_text'], '$f.submit_text'),
      subredditType: parseString(m['subreddit_type'], '$f.subreddit_type'),
      subscribers: parseInt(m['subscribers'], '$f.subscribers'),
      title: parseString(m['title'], '$f.title'),
      url: parseString(m['url'], '$f.url'),
      headerImg: parseUrl(m['header_img'], '$f.header_img'),
      bannerBackgroundImage:
          parseUrl(m['banner_background_image'], '$f.banner_background_image'),
      bannerBackgroundColor: parseColor(
          m['banner_background_color'], '$f.banner_background_color'),
      userIsSubscriber:
          parseBool(m['user_is_subscriber'], '$f.user_is_subscriber'),
      userHasFavorited:
          parseBool(m['user_has_favorited'], '$f.user_has_favorited'),
    );
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
    );
  }

  @override
  List<Object> get props {
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
    ];
  }
}
