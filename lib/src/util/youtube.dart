// String? parseYoutubeId(String url) {
//   // https://youtu.be/_DsnAxYNRCU
//   // https://youtu.be/Q57ZeqJGHz4

//   // https://www.youtube.com/watch?v=sN1g_skbwhk
//   // https://www.youtube.com/watch?v=sN1g_skbwhk&t=20s
// }

YoutubeVideo? parseYoutubeUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) {
    return null;
  }

  // https://youtu.be/_DsnAxYNRCU
  // https://youtu.be/Y3ttMh5a-dQ?t=12728
  if (uri.host == 'youtu.be') {
    final id = _parseId(uri.path);
    final startAt = _parseStartAt(uri.queryParameters['t'] ?? '');
    if (id == '') {
      return null;
    }
    return YoutubeVideo(id: id, startAt: startAt);
  }

  // https://www.youtube.com/watch?v=sN1g_skbwhk
  // https://www.youtube.com/watch?v=sN1g_skbwhk&t=20s
  if (uri.host == 'www.youtube.com' || uri.host == 'youtube.com') {
    final id = _parseId(uri.queryParameters['v'] ?? '');
    final startAt = _parseStartAt(uri.queryParameters['t'] ?? '');
    if (id == '') {
      return null;
    }
    return YoutubeVideo(id: id, startAt: startAt);
  }

  return null;
}

final _idRegExp = RegExp(r'^[0-9a-zA-Z_\-]+$');

String _parseId(String s) {
  if (_idRegExp.hasMatch(s)) {
    return s;
  }
  return '';
}

int _parseStartAt(String s) {
  final startAt = int.tryParse(s.replaceAll('s', ''));
  if (startAt == null) {
    return 0;
  }
  if (startAt < 0) {
    return 0;
  }
  return startAt;
}

class YoutubeVideo {
  String id;
  int startAt;

  YoutubeVideo({
    required this.id,
    required this.startAt,
  }) {
    if (id == '') {
      throw Exception('id is empty');
    }
    if (startAt < 0) {
      throw Exception('startAt < 0');
    }
  }
}
