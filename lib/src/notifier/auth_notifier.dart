import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../logging/logging.dart';
import '../reddit_api/reddit_api.dart';
import 'current_user_notifier.dart';
import 'try_mixin.dart';

class AuthNotifier with TryMixin, ChangeNotifier {
  AuthNotifier(this._redditApi);

  final RedditApi _redditApi;

  static final _log = getLogger('AuthNotifier');
  Logger get log => _log;

  CurrentUserNotifier? _user;
  CurrentUserNotifier? get user => _user;

  Future<bool> loginSilently() async {
    return try_<bool>(() async {
      if (_redditApi.isLoggedIn) {
        return true;
      }
      if (await _redditApi.loginSilently()) {
        await _loadUser();
        notifyListeners();
        return true;
      }
      return false;
    }, 'fail to login silently');
  }

  Future<void> login() {
    return try_(() async {
      if (_redditApi.isLoggedIn) {
        return;
      }
      await _redditApi.login();
      await _loadUser();
      notifyListeners();
    }, 'fail to login');
  }

  Future<void> _loadUser() async {
    final user = await _redditApi.currentUser();
    if (user == null) {
      throw Exception('user is null');
    }
    _user = CurrentUserNotifier(_redditApi, user);
  }

  Future<void> logout() {
    return try_(() async {
      if (!_redditApi.isLoggedIn) {
        return;
      }
      await _redditApi.logout();
      _user = null;
      notifyListeners();
    }, 'fail to logout');
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}
