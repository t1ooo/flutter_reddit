const _year = Duration(days: 1 * 365);
const _month = Duration(days: 1 * 30);

// TODO: replace DateTime.now() to Clock
String formatDateTime(DateTime dTime) {
  final diff = DateTime.now().difference(dTime);

  if (diff >= _year) {
    return '${diff.inMicroseconds ~/ _year.inMicroseconds}y';
  }
  if (diff >= _month) {
    return '${diff.inMicroseconds ~/ _month.inMicroseconds}m';
  }
  if (diff.inDays > 0) {
    return '${diff.inDays}d';
  }
  if (diff.inHours > 0) {
    return '${diff.inHours}h';
  }
  if (diff.inMinutes > 0) {
    return '${diff.inMinutes}m';
  }

  return '${diff.inSeconds}s';
}
