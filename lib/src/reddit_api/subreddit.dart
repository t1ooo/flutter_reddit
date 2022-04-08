import 'package:draw/draw.dart' as draw;
import 'package:equatable/equatable.dart';

import '../logging/logging.dart';
import '../util/cast.dart';

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

  static final _log = Logger('Subreddit');

  factory Subreddit.fromDrawSubreddit(draw.Subreddit sub) {
    final data = sub.data!;

    return Subreddit(
      communityIcon: data['community_icon'],
      created: _parseTime(data['created']),
      createdUtc: _parseTime(data['created_utc'], isUtc: true),
      description: cast(data['description'], ''),
      descriptionHtml: cast(data['description_html'], ''),
      displayName: sub.displayName,
      displayNamePrefixed: cast(data['display_name_prefixed'], ''),
      id: cast(data['id'], ''),
      lang: cast(data['lang'], ''),
      name: cast(data['name'], ''),
      publicDescription: cast(data['public_description'], ''),
      publicDescriptionHtml: cast(data['public_description_html'], ''),
      submitTextHtml: cast(data['submit_text_html'], ''),
      submitText: cast(data['submit_text'], ''),
      subredditType: cast(data['subreddit_type'], ''),
      subscribers: cast(data['subscribers'], 0),
      title: sub.title,
      url: cast(data['url'], ''),
    );
  }

  // static DateTime _parseTime(dynamic data) {
  //   final num = double.tryParse(data);
  //   if (num == null) {
  //     _log.warning('fail to parse time: $data');
  //     return DateTime.now();
  //   }
  //   return DateTime(num.toInt());
  // }
  static DateTime _parseTime(dynamic data, {bool isUtc = false}) {
    final num = cast<double>(data, 0.0);
    if (num == 0.0) {
      _log.warning('fail to parse time: $data');
      return DateTime.now();
    }
    // return DateTime(num.toInt());
    return DateTime.fromMillisecondsSinceEpoch(
      num.round() * 1000,
      isUtc: isUtc,
    );
  }

  @override
  // TODO: implement props
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
    ];
  }
}
