import 'package:equatable/equatable.dart';

import '../logging/logging.dart';
import '../util/map.dart';
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
    required this.userIsSubscriber,
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
  final bool userIsSubscriber;

  // static final _log = getLogger('Subreddit');

  // factory Subreddit.fromDrawSubreddit(draw.Subreddit sub) {
  factory Subreddit.fromJson(Map data) {
    // final data = sub.data!;
    return Subreddit(
      communityIcon: parseUrl(data['community_icon'], _log),
      created: parseTime(data['created'], false, _log),
      createdUtc: parseTime(data['created_utc'], true, _log),
      description: mapGet(data, 'description', '', _log),
      descriptionHtml: mapGet(data, 'description_html', '', _log),
      displayName: mapGet(data, 'display_name', '', _log),
      displayNamePrefixed: mapGet(data, 'display_name_prefixed', '', _log),
      id: mapGet(data, 'id', '', _log),
      lang: mapGet(data, 'lang', '', _log),
      name: mapGet(data, 'name', '', _log),
      publicDescription: mapGet(data, 'public_description', '', _log),
      publicDescriptionHtml: mapGet(data, 'public_description_html', '', _log),
      submitTextHtml: mapGet(data, 'submit_text_html', '', _log),
      submitText: mapGet(data, 'submit_text', '', _log),
      subredditType: mapGet(data, 'subreddit_type', '', _log),
      subscribers: mapGet(data, 'subscribers', 0, _log),
      title: mapGet(data, 'title', '', _log),
      url: mapGet(data, 'url', '', _log),
      headerImg: parseUrl(data['header_img'], _log),
      bannerBackgroundImage: parseUrl(data['banner_background_image'], _log),
      userIsSubscriber: mapGet(data, 'user_is_subscriber', false, _log),
    );
  }

  static final _log = getLogger('Subreddit');


  // static String _parseIcon(dynamic data) {
  //   final s = cast<String>(data, '');
  //   if (s == '') {
  //     _log.warning('fail to parse icon: $data');
  //     return '';
  //   }
  //   if (!s.startsWith('http')) {
  //     _log.warning('fail to parse icon: $data');
  //     return '';
  //   }
  //   final uri = Uri.tryParse(s);
  //   if (uri == null) {
  //     _log.warning('fail to parse icon: $data');
  //     return '';
  //   }
  //   return uri.scheme + ':' + '//' + uri.authority + uri.path;
  // }

  // static DateTime _parseTime(dynamic data) {
  //   final num = double.tryParse(data);
  //   if (num == null) {
  //     _log.warning('fail to parse time: $data');
  //     return DateTime.now();
  //   }
  //   return DateTime(num.toInt());
  // }
  // static DateTime _parseTime(dynamic data, {bool isUtc = false}) {
  //   final num = cast<double>(data, 0.0);
  //   if (num == 0.0) {
  //     _log.warning('fail to parse time: $data');
  //     return DateTime.now();
  //   }
  //   // return DateTime(num.toInt());
  //   return DateTime.fromMillisecondsSinceEpoch(
  //     num.round() • 1000,
  //     isUtc: isUtc,
  //   );
  // }

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
    bool? userIsSubscriber,
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
      userIsSubscriber: userIsSubscriber ?? this.userIsSubscriber,
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
      userIsSubscriber,
    ];
  }
}
