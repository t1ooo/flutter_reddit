extension UriIsEmpty on Uri {
  bool get isEmpty => toString() == '';
  bool get isNotEmpty => !isEmpty;
}
