import '../reddit_api/reddit_api.dart';
import 'base_notifier.dart';
import 'user_notifier.dart';

class UserLoaderNotifier extends BaseNotifier {
  UserLoaderNotifier(this._redditApi);

  final RedditApi _redditApi;

  String? _name;

  UserNotifier? _user;
  UserNotifier? get user => _user;

  Future<void> loadUser(String name) {
    return try_(
      () async {
        if (_user != null && _name == name) return;
        _name = name;

        _user = UserNotifier(_redditApi, await _redditApi.user(_name!));
        notifyListeners();
      },
      'fail to load user',
    );
  }
}
