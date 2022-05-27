YoutubeVideo? parseYoutubeUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) {
    return null;
  }

  if (uri.host == 'youtu.be') {
    final id = _parseId(uri.path);
    final startAt = _parseStartAt(uri.queryParameters['t'] ?? '');
    if (id == '') {
      return null;
    }
    return YoutubeVideo(id: id, startAt: startAt);
  }

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

  String id;
  int startAt;
}
