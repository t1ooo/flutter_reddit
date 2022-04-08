import 'package:draw/draw.dart' as draw;
import 'package:equatable/equatable.dart';

import '../logging/logging.dart';
import '../util/cast.dart';
import '../util/map.dart';

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
      communityIcon: _parseIcon(data['community_icon']),
      created: _parseTime(data['created']),
      createdUtc: _parseTime(data['created_utc'], isUtc: true),
      description: mapGet(data, 'description', ''),
      descriptionHtml: mapGet(data, 'description_html', ''),
      displayName: sub.displayName,
      displayNamePrefixed: mapGet(data, 'display_name_prefixed', ''),
      id: mapGet(data, 'id', ''),
      lang: mapGet(data, 'lang', ''),
      name: mapGet(data, 'name', ''),
      publicDescription: mapGet(data, 'public_description', ''),
      publicDescriptionHtml: mapGet(data, 'public_description_html', ''),
      submitTextHtml: mapGet(data, 'submit_text_html', ''),
      submitText: mapGet(data, 'submit_text', ''),
      subredditType: mapGet(data, 'subreddit_type', ''),
      subscribers: mapGet(data, 'subscribers', 0),
      title: sub.title,
      url: mapGet(data, 'url', ''),
    );
  }

  static String _parseIcon(dynamic data) {
    final s = cast<String>(data, '');
    if (s == '') {
      _log.warning('fail to parse icon: $data');
      return '';
    }
    final uri = Uri.tryParse(s);
    if (uri == null) {
      _log.warning('fail to parse icon: $data');
      return '';
    }
    return uri.scheme + ':' + '//' + uri.authority + uri.path;
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
