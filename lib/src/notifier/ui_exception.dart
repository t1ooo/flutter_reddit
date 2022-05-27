class UIException implements Exception {
  UIException(this._message);
  final String _message;
  @override
  String toString() => _message;
}
