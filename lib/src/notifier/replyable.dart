abstract class Replyable {
  String get replyToMessage;
  Future<void> reply(String message);
}
