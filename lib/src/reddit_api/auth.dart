import 'dart:async';

import 'package:alfred/alfred.dart';
import 'package:uni_links/uni_links.dart';

import '../logging.dart';
import '../util/uri.dart';

abstract class Auth {
  Stream<String> get stream;
  Uri get redirectUri;
  Future<void> close();
}

class DesktopAuth implements Auth {
  DesktopAuth(this.redirectUri) {
    if (redirectUri.isEmpty) {
      throw Exception('auth.redirectUri is empty');
    }

    _app = Alfred();
    _stream = _s.stream.asBroadcastStream();
    _app.get(redirectUri.path, _handleAuthRequest);
    // ignore: invalid_return_type_for_catch_error
    _app.listen(redirectUri.port).catchError(_onError);
  }

  FutureOr<dynamic> _handleAuthRequest(HttpRequest req, HttpResponse res) {
    final authCode = req.uri.queryParameters['code'] ?? '';
    if (authCode == '') {
      _log.warning('auth code is empty');
      return 'Something went wrong! Close the page and try to log in again.';
    } else {
      _s.add(authCode);
      return 'Authorization successfully! Close the page and return to the application.';
    }
  }

  static final _log = getLogger('AuthServer');
  final _s = StreamController<String>();
  late final Alfred _app;
  @override
  final Uri redirectUri;
  @override
  Stream<String> get stream => _stream;
  late final Stream<String> _stream;

  void _onError(dynamic e) {
    _log.error(e);
  }

  @override
  Future<void> close() async {
    await _app.close();
    await _s.close();
  }
}

class AndroidAuth implements Auth {
  AndroidAuth(this.redirectUri) {
    if (redirectUri.isEmpty) {
      throw Exception('auth.redirectUri is empty');
    }

    _stream = _s.stream.asBroadcastStream();
    getInitialLink().then(
      (link) {
        _add(link, true);
        _sub = linkStream.listen(_add, onError: _onError);
      },
      onError: _onError,
    );
  }

  static final _log = getLogger('AndroidAuth');
  final _s = StreamController<String>();
  StreamSubscription<String?>? _sub;
  @override
  final Uri redirectUri;
  @override
  Stream<String> get stream => _stream;
  late final Stream<String> _stream;

  void _add(String? link, [bool isInitialLink = false]) {
    final authCode = Uri.parse(link ?? '').queryParameters['code'] ?? '';
    if (authCode == '') {
      (isInitialLink ? _log.info : _log.warning)('auth code is empty');
      return;
    }
    _s.add(authCode);
  }

  void _onError(dynamic e) {
    _log.error(e);
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    await _s.close();
  }
}
