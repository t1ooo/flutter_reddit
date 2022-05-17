String enumToString(dynamic e) {
  if (e == null) {
    return '';
  }
  return e.toString().split('.').last;
}
