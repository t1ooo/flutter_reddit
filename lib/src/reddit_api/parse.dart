import '../logging/logging.dart';
import '../util/cast.dart';

final _log = Logger('parserLog');

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
  return s;
}

String parseIcon(dynamic data) {
  final s = parseUri(data);
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
    return (data as List<dynamic>)
        .map((v) {
          return v['resized_icons'][0]['url'];
        })
        .where((v) {
          return (v is String) &&
              v.startsWith('http') &&
              v.contains('redditstatic.com');
        })
        .map((v) => v as String)
        .toList();
  } on Exception catch (e) {
    _log.warning(e);
    return [];
  }
}
