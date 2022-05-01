// TODO: move not shared functions to file
// TODO: use one logger per folder

import 'package:flutter_reddit_prototype/src/reddit_api/comment.dart';

import '../logging/logging.dart';
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

String parseText(dynamic data) {
  final text = cast<String>(data, '');
  return text.replaceAll('&lt;', '<').replaceAll('&gt;', '>');
}

Vote parseLikes(dynamic data, [Logger? log]) {
  if(data == null) {
    return Vote.none;
  }
  if(data == true) {
    return Vote.up;
  }
  if(data == false) {
    return Vote.up;
  }

  log?.warning('fail to parse likes: $data');
  return Vote.none;
}

List<Comment> parseCommentReplies(dynamic data, [Logger? log]) {
  try {
    final comments = <Comment>[];
    for (final child in (data?['data']?['children'] as List<dynamic>)) {
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

  // final children = data?['data']?['children'];
  // if (!(children is List)) {
  //   log?.warning('fail to parse comment replies: $data');
  // }

  // final comments = <Comment>[];
  // for (final child in children) {
  //   final childData = child['data'];
  //   if (!(children is Map)) {
  //     log?.warning('fail to parse comment: $childData');
  //   }
  //   comments.add(Comment.fromJson(childData as Map));
  // }

  // return [];
}

String parseUrl(dynamic data, [Logger? log]) {
  final s = cast<String>(data, '');
  if (s == '') {
    log?.warning('fail to parse uri: $data');
    return '';
  }
  if (!s.startsWith('http')) {
    log?.warning('fail to parse uri: $data');
    return '';
  }
  // return s;
  return s.replaceAll('&amp;', '&');
}

// String parseIcon(dynamic data) {
//   final s = parseUrl(data);
//   final uri = Uri.tryParse(s);
//   if (uri == null) {
//     log?.warning('fail to parse icon: $data');
//     return '';
//   }
//   return uri.scheme + ':' + '//' + uri.authority + uri.path;
// }

// static DateTime _parseTime(dynamic data) {
//   final num = double.tryParse(data);
//   if (num == null) {
//     log?.warning('fail to parse time: $data');
//     return DateTime.now();
//   }
//   return DateTime(num.toInt());
// }
DateTime parseTime(dynamic data, bool isUtc, [Logger? log]) {
  final num = cast<double>(data, 0);
  if (num == 0.0) {
    log?.warning('fail to parse time: $data');
    return DateTime.now();
  }
  // return DateTime(num.toInt());
  return DateTime.fromMillisecondsSinceEpoch(
    num.round() * 1000,
    isUtc: isUtc,
  );
}

// String parseThumbnail(dynamic data) {
//   try {
//     return data.startsWith('http') ? data : '';
//   } on Exception catch (e) {
//     log?.warning(e);
//     return '';
//   }
// }

List<String> parseAwardIcons(dynamic data, [Logger? log]) {
  try {
    // return (data as List<dynamic>)
    //     .map((v) {
    //       return v?['resized_icons']?[0]?['url'];
    //     })
    //     .where((v) {
    //       return (v is String) && v.startsWith('http');
    //       // v.contains('redditstatic.com');
    //     })
    //     .map((v) => (v as String).replaceAll('&amp;', '&'))
    //     .toList();

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
