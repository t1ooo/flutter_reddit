import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../logging/logging.dart';
import '../reddit_api/message.dart';
import '../reddit_api/reddit_api.dart';
import 'try_mixin.dart';

class MessageNotifier extends ChangeNotifier with TryMixin {
  MessageNotifier(this._redditApi, this._message);

  final RedditApi _redditApi;
  static final _log = getLogger('MessageNotifier');

  Message _message;
  Message get message => _message;

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}
