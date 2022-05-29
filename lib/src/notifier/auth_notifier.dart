import '../logging.dart';
import '../reddit_api/reddit_api.dart';
import 'base_notifier.dart';
import 'current_user_notifier.dart';

class AuthNotifier extends BaseNotifier {
  AuthNotifier(this._redditApi);

  final RedditApi _redditApi;

  CurrentUserNotifier? _user;
  CurrentUserNotifier? get user => _user;

  Future<bool> loginSilently() async {
    return try_<bool>(
      () async {
        if (_redditApi.isLoggedIn) return true;

        if (await _redditApi.loginSilently()) {
          await _loadUser();
          notifyListeners();
          return true;
        }
        return false;
      },
      'fail to login silently',
    );
  }

  Future<void> login() {
    return try_(
      () async {
        if (_redditApi.isLoggedIn) return;

        await _redditApi.login();
        await _loadUser();
        notifyListeners();
      },
      'fail to login',
    );
  }

  Future<void> _loadUser() async {
    try {
      final user = await _redditApi.currentUser();
      if (user == null) {
        throw Exception('user is empty');
      }
      _user = CurrentUserNotifier(_redditApi, user);
    } on Exception catch (e, st) {
      log.error('', e, st);
      await _redditApi.logout();
      rethrow;
    }
  }

  Future<void> logout() {
    return try_(
      () async {
        if (!_redditApi.isLoggedIn) return;

        await _redditApi.logout();
        _user = null;
        notifyListeners();
      },
      'fail to logout',
    );
  }
}
