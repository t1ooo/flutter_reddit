abstract class Replyable {
  String get replyToMessage => throw UnimplementedError();
  Future<void> reply(String message) => throw UnimplementedError();
}
