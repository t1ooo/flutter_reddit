import 'dart:async';
import 'dart:io';

import 'package:uni_links/uni_links.dart';
import 'package:alfred/alfred.dart';

import '../logging.dart';

abstract class Auth {
  Stream<String> get stream;
  Uri get redirectUri;
  Future<void> close();
}

class DesktopAuth implements Auth {
  DesktopAuth(this.redirectUri) {
    _app = Alfred();
    // stream = _s.stream;
    _app.get(redirectUri.path, _handleAuthRequest);
    _app.listen(redirectUri.port).catchError(_onError);
  }

  FutureOr _handleAuthRequest(HttpRequest req, HttpResponse res) {
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
  final Uri redirectUri;
  late final Alfred _app;
  // late final Stream<String> stream;
  Stream<String> get stream => _s.stream;

  void _onError(dynamic e) {
    _log.error(e);
  }

  Future<void> close() async {
    await _app.close();
    await _s.close();
  }
}

class AndroidAuth implements Auth {
  AndroidAuth(this.redirectUri) {
    getInitialLink().then((link) {
      _add(link, true);
      _sub = linkStream.listen(_add, onError: _onError);
    }, onError: _onError);
  }

  static final _log = getLogger('AndroidAuth');
  final _s = StreamController<String>();
  final Uri redirectUri;
  // late final Stream<String> stream;
  StreamSubscription? _sub;

  Stream<String> get stream => _s.stream;

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

  Future<void> close() async {
    await _sub?.cancel();
    await _s.close();
  }
}

// TODO: add encryption
class Credentials {
  Credentials(this.file);

  File file;

  Future<String> read() async {
    return file.existsSync() ? await file.readAsString() : '';
  }

  Future<void> write(String data) async {
    await file.writeAsString(data);
  }

  Future<void> delete() async {
    await file.delete();
  }
}
