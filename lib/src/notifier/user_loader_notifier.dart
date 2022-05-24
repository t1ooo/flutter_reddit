import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../logging.dart';
import '../reddit_api/reddit_api.dart';
import 'try_mixin.dart';
import 'user_notifier.dart';

class UserLoaderNotifier with TryMixin, ChangeNotifier {
  UserLoaderNotifier(this._redditApi);

  final RedditApi _redditApi;

  static final _log = getLogger('UserLoaderNotifier');
  Logger get log => _log;

  // void reset() {
  //   _name = null;
  //   _user = null;
  //   // notifyListeners();
  // }

  String? _name;

  UserNotifier? _user;
  UserNotifier? get user => _user;

  Future<void> loadUser(String name) {
    return try_(() async {
      if (_user != null && _name == name) return;
      _name = name;

      _user = UserNotifier(_redditApi, await _redditApi.user(_name!));
      notifyListeners();
    }, 'fail to load user');
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}
