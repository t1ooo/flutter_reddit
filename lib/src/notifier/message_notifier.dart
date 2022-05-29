import '../reddit_api/message.dart';
import '../reddit_api/reddit_api.dart';
import 'base_notifier.dart';

class MessageNotifier extends BaseNotifier {
  MessageNotifier(this._redditApi, this._message);

  // ignore: unused_field
  final RedditApi _redditApi;

  final Message _message;
  Message get message => _message;
}
