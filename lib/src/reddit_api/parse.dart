import 'package:clock/clock.dart';

import '../logging.dart';

import 'comment.dart';
import 'post_hint.dart';
import 'preview_images.dart';
import 'rule.dart';
import 'video.dart';
import 'like.dart';

final _parserLog = getLogger('parse');

void _log(Object message, [String? name, StackTrace? st]) {
  name != null
      ? _parserLog.warning('$name: $message', null, st)
      : _parserLog.warning(message, null, st);
}

T cast<T>(dynamic data, T defaultValue, [String? name]) {
  try {
    if (data == null) {
      return defaultValue;
    }

    return data as T;
  } on TypeError catch (_) {
    _log('fail to cast: <${data.runtimeType}> to <$T>', name);
    return defaultValue;
  }
}

final colorRegExp = RegExp(r'^#[0-9abcdef]{3,8}$', caseSensitive: false);

String parseColor(dynamic data, [String? name]) {
  if (data == null || data == '') {
    return '';
  }
  final text = parseString(data, name);
  if (colorRegExp.hasMatch(text)) {
    return text;
  }
  _log('fail to parse color: $data', name);
  return '';
}

String parseBody(dynamic data, [String? name]) {
  final text = parseString(data, name);
  return text.replaceAll('&lt;', '<').replaceAll('&gt;', '>');
}

Like parseLikes(dynamic data, [String? name]) {
  if (data == null) {
    return Like.none;
  }
  if (data == true) {
    return Like.up;
  }
  if (data == false) {
    return Like.up;
  }

  _log('fail to parse likes: $data', name);
  return Like.none;
}

List<Comment> parseReplies(dynamic data, [String? name]) {
  try {
    if (data == null || data == '') {
      return [];
    }

    final comments = <Comment>[];
    for (final v in (data['data']?['children'] as List<dynamic>)) {
      try {
        if (v['children'] == 't1') {
          comments.add(Comment.fromJson(v['data']));
        }
      } on TypeError catch (e) {
        _log('$e: $v', name);
      }
    }
    return comments;
  } on TypeError catch (e) {
    _log('$e: $data', name);
    return [];
  }
}

String parseUrl(dynamic data, [String? name]) {
  if (data == null ||
      data == '' ||
      data == 'self' ||
      data == 'default' ||
      data == 'image' ||
      data == 'spoiler') {
    return '';
  }

  if (!(data.startsWith('http://') || data.startsWith('https://'))) {
    _log('fail to parse uri: $data', name);
    return '';
  }

  return data.replaceAll('&amp;', '&');
}

DateTime parseTime(dynamic data, [String? name]) {
  return _parseTime(data, false, name);
}

DateTime parseTimeUtc(dynamic data, [String? name]) {
  return _parseTime(data, true, name);
}

DateTime _parseTime(dynamic data, bool isUtc, [String? name]) {
  if (data == null) {
    return clock.now();
  }
  final num = parseDouble(data, name);
  if (num == 0) {
    _log('fail to parse time: $data', name);
    return clock.now();
  }

  return DateTime.fromMillisecondsSinceEpoch(
    num.round() * 1000,
    isUtc: isUtc,
  );
}

String parseSubmissionId(dynamic data, [String? name]) {
  final s = parseString(data, name).split('_');
  return s.isEmpty ? '' : s.last;
}

List<String> parseAwardIcons(dynamic data, [String? name]) {
  try {
    if (data == null) {
      return [];
    }

    return (data as List<dynamic>).map((v) {
      return parseUrl(v?['resized_icons']?[0]?['url']);
    }).where((v) {
      return v != '';
    }).toList();
  } on TypeError catch (e) {
    _log('$e: $data', name);
    return [];
  }
}

List<Previews> parsePreviews(dynamic data, [String? name]) {
  try {
    if (data == null) {
      return [];
    }

    final images = <Previews>[];
    for (final v in (data['images'] as List<dynamic>)) {
      try {
        images.add(Previews.fromJson(v));
      } on TypeError catch (e) {
        _log('$e: $v', name);
      }
    }
    return images;
  } on TypeError catch (e) {
    _log('$e: $data', name);
    return [];
  }
}

List<Preview> parsePreview(dynamic data, [String? name]) {
  try {
    if (data == null) {
      return [];
    }

    final images = <Preview>[];

    for (final v in (data['images'] as List<dynamic>)) {
      try {
        images.add(Preview.fromJson(v['variants']?['gif'] ?? v));
      } on TypeError catch (e) {
        _log('$e: $v', name);
      }
    }
    return images;
  } on TypeError catch (e) {
    _log('$e: $data', name);
    return [];
  }
}

Video? parseVideo(dynamic data, [String? name]) {
  try {
    final video = data?['reddit_video'];
    if (video == null) {
      return null;
    }
    return Video.fromJson(video);
  } on TypeError catch (e) {
    _log('$e: $data', name);
    return null;
  }
}

List<Rule>? parseRules(dynamic data, [String? name]) {
  try {
    if (data == null) {
      return [];
    }

    final rules = <Rule>[];
    for (final v in (data['rules'] as List<dynamic>)) {
      try {
        rules.add(Rule.fromJson(v));
      } on TypeError catch (e) {
        _log('$e: $v', name);
      }
    }
    return rules;
  } on TypeError catch (e) {
    _log('$e: $data', name);
    return [];
  }
}

double parsePositiveDouble(dynamic data, [String? name]) {
  final d = parseDouble(data, name);
  if (d < 0) {
    return 0;
  }
  return d;
}

double parseDouble(dynamic data, [String? name]) {
  const defaultValue = 0.0;

  if (data == null) {
    return defaultValue;
  }
  if (data is double) {
    return data;
  }
  if (data is num) {
    return data.toDouble();
  }
  if (data is String) {
    return double.tryParse(data) ?? defaultValue;
  }
  _log('fail to parse double: $data', name);
  return defaultValue;
}

int parsePositiveInt(dynamic data, [String? name]) {
  final d = parseInt(data, name);
  if (d < 0) {
    return 0;
  }
  return d;
}

int parseInt(dynamic data, [String? name]) {
  const defaultValue = 0;

  if (data == null) {
    return defaultValue;
  }
  if (data is int) {
    return data;
  }
  if (data is num) {
    return data.toInt();
  }
  if (data is String) {
    return int.tryParse(data) ?? defaultValue;
  }
  _log('fail to parse int: $data', name);
  return defaultValue;
}

String parseString(dynamic data, [String? name]) {
  const defaultValue = '';

  if (data == null) {
    return defaultValue;
  }
  if (data is String) {
    return data;
  }
  _log('fail to parse string: $data', name);
  return defaultValue;
}

final markdownRegExp = RegExp(r'#+');

String parseMarkdown(dynamic data, [String? name]) {
  final text = parseBody(data, name);
  return text.replaceAllMapped(RegExp(r'#+'), (m) {
    return ' ${m.group(0)} ';
  });
}

bool parseBool(dynamic data, [String? name]) {
  const defaultValue = false;

  if (data == null) {
    return defaultValue;
  }
  if (data is bool) {
    return data;
  }
  _log('fail to parse bool: $data', name);
  return defaultValue;
}

List<String> parseListString(dynamic data, [String? name]) {
  if (data == null) {
    return [];
  }
  if (!(data is List)) {
    _log('fail to parse List<string>: $data', name);
    return [];
  }
  return data.map((v) => parseString(v, name)).where((v) => v != '').toList();
}

PostHint parsePostHint(dynamic data, dynamic url, [String? name]) {
  if (data == null) {
    return PostHint.none;
  }

  switch (data) {
    case 'hosted:video':
      return PostHint.hostedVideo;
    case 'image':
      return PostHint.image;
    case 'link':
      return (parseUrl(url) != '') ? PostHint.link : PostHint.self;
    case 'rich:video':
      return PostHint.richVideo;
    case 'self':
      return PostHint.self;
  }

  _log('fail to parse post hint: $data', name);
  return PostHint.none;
}
