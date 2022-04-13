// TODO: move not shared functions to file
// TODO: use one logger per folder

import 'package:flutter_reddit_prototype/src/reddit_api/comment.dart';

import '../logging/logging.dart';
import '../util/cast.dart';

final _log = Logger('parserLog');

List<Comment> parseCommentReplies(dynamic data) {
  try {
    final comments = <Comment>[];
    for (final child in (data?['data']?['children'] as List<dynamic>)) {
      try {
        comments.add(Comment.fromMap(child?['data'] as Map));
      } on TypeError catch (e) {
        _log.warning(e);
      }
    }
    return comments;
  } on TypeError catch (e) {
    _log.warning(e);
    return [];
  }

  // final children = data?['data']?['children'];
  // if (!(children is List)) {
  //   _log.warning('fail to parse comment replies: $data');
  // }

  // final comments = <Comment>[];
  // for (final child in children) {
  //   final childData = child['data'];
  //   if (!(children is Map)) {
  //     _log.warning('fail to parse comment: $childData');
  //   }
  //   comments.add(Comment.fromMap(childData as Map));
  // }

  // return [];
}

String parseUri(dynamic data) {
  final s = cast<String>(data, '');
  if (s == '') {
    _log.warning('fail to parse uri: $data');
    return '';
  }
  if (!s.startsWith('http')) {
    _log.warning('fail to parse uri: $data');
    return '';
  }
  // return s;
  return s.replaceAll('&amp;', '&');
}

// String parseIcon(dynamic data) {
//   final s = parseUri(data);
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
DateTime parseTime(dynamic data, {bool isUtc = false}) {
  final num = cast<double>(data, 0);
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

// String parseThumbnail(dynamic data) {
//   try {
//     return data.startsWith('http') ? data : '';
//   } on Exception catch (e) {
//     _log.warning(e);
//     return '';
//   }
// }

List<String> parseAwardIcons(dynamic data) {
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
      return parseUri(v?['resized_icons']?[0]?['url']);
    }).where((v) {
      return v != '';
    }).toList();
  } on Exception catch (e) {
    _log.warning(e);
    return [];
  }
}
