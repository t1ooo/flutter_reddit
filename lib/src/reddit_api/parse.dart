import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/reddit_api/comment.dart';

import '../logging/logging.dart';
import 'preview_images.dart';
import 'video.dart';
import 'vote.dart';

T cast<T>(dynamic v, T defaultValue, [Logger? log]) {
  try {
    return v as T;
  } on TypeError catch (_) {
    log?.warning('fail to cast: $v to <$T>');
    return defaultValue;
  }
}

T mapGet<T>(Map m, String key, T defaultValue, [Logger? log]) {
  final val = m[key];
  try {
    return val as T;
  } on TypeError catch (_) {
    log?.warning('fail to cast: {$key: $val} to <$T>');
    return defaultValue;
  }
}

List<T> mapGetList<T>(Map m, String key, List<T> defaultValue, [Logger? log]) {
  final val = m[key];
  try {
    return (val as List).cast<T>();
  } on TypeError catch (_) {
    // _log.warning(e);
    log?.warning('fail to cast: {$key: $val} to List<$T>');
    return defaultValue;
  }
}

final colorRegExp = RegExp(r'^#[0-9abcdef]{3,8}$', caseSensitive: false);

String parseColor(dynamic data, [Logger? log]) {
  if (data == null || data == '') {
    return '';
  }

  final text = cast<String>(data, '');
  if (colorRegExp.hasMatch(text)) {
    return text;
  }
  log?.warning('fail to parse color: $data');
  return '';
}

String parseText(dynamic data) {
  if (data == null || data == '') {
    return '';
  }

  final text = cast<String>(data, '');
  return text.replaceAll('&lt;', '<').replaceAll('&gt;', '>');
}

Vote parseLikes(dynamic data, [Logger? log]) {
  if (data == null) {
    return Vote.none;
  }
  if (data == true) {
    return Vote.up;
  }
  if (data == false) {
    return Vote.up;
  }

  log?.warning('fail to parse likes: $data');
  return Vote.none;
}

List<Comment> parseCommentReplies(dynamic data, [Logger? log]) {
  try {
    if (data == null) {
      return [];
    }

    final comments = <Comment>[];
    for (final child in (data as List<dynamic>)) {
      try {
        comments.add(Comment.fromJson(child?['data'] as Map));
      } on TypeError catch (e) {
        log?.warning(e);
      }
    }
    return comments;
  } on TypeError catch (e) {
    log?.warning(e);
    return [];
  }
}

String parseUrl(dynamic data, [Logger? log]) {
  if (data == null || data == '') {
    return '';
  }

  final s = cast<String>(data, '');
  if (s == '') {
    log?.warning('fail to parse uri: $data');
    return '';
  }
  if (!s.startsWith('http')) {
    log?.warning('fail to parse uri: $data');
    return '';
  }

  return s.replaceAll('&amp;', '&');
}

DateTime parseTime(dynamic data, bool isUtc, [Logger? log]) {
  final num = cast<double>(data, 0);
  if (num == 0.0) {
    log?.warning('fail to parse time: $data');
    return DateTime.now();
  }

  return DateTime.fromMillisecondsSinceEpoch(
    num.round() * 1000,
    isUtc: isUtc,
  );
}

List<String> parseAwardIcons(dynamic data, [Logger? log]) {
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
    log?.warning(e);
    return [];
  }
}

List<PreviewImages> parseSubmissionPreview(dynamic data, [Logger? log]) {
  try {
    if (data == null) {
      return [];
    }

    final images = <PreviewImages>[];
    for (final v in (data as List<dynamic>)) {
      try {
        images.add(PreviewImages.fromJson(v));
      } on TypeError catch (e) {
        log?.warning(e);
      }
    }
    return images;
  } on TypeError catch (e) {
    log?.warning(e);
    return [];
  }
}

Video? parseSubmissionVideo(dynamic data, [Logger? log]) {
  try {
    if (data == null) {
      return null;
    }
    return Video.fromJson(data);
  } on TypeError catch (e) {
    log?.warning(e);
    return null;
  }
}

double parsePositiveDouble(dynamic data, [Logger? log]) {
  final d = parseDouble(data, log);
  if (d < 0) {
    return 0;
  }
  return d;
}

double parseDouble(dynamic data, [Logger? log]) {
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
  log?.warning('fail to parse double: $data');
  return defaultValue;
}

int parsePositiveInt(dynamic data, [Logger? log]) {
  final d = parseInt(data, log);
  if (d < 0) {
    return 0;
  }
  return d;
}

int parseInt(dynamic data, [Logger? log]) {
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
  log?.warning('fail to parse int: $data');
  return defaultValue;
}


String parseString(dynamic data, [Logger? log]) {
  const defaultValue = '';

  if (data == null) {
    return defaultValue;
  }
  if (data is String) {
    return data;
  }
  log?.warning('fail to parse string: $data');
  return defaultValue;
}

bool parseBool(dynamic data, [Logger? log]) {
  const defaultValue = false;

  if (data == null) {
    return defaultValue;
  }
  if (data is bool) {
    return data;
  }
  log?.warning('fail to parse bool: $data');
  return defaultValue;
}
