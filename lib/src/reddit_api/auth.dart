import 'dart:async';
import 'dart:io';

import 'package:alfred/alfred.dart';

class AuthServer {
  AuthServer(Uri redirectUri) {
    _app = Alfred();
    _s = StreamController<String>();
    stream = _s.stream;

    _app.get(redirectUri.path, (HttpRequest req, HttpResponse res) {
      final authCode = req.uri.queryParameters['code'] ?? '';
      _s.add(authCode);
      return 'Authorization successfully! Close the page and return to the application.';
    });
    _app.listen(redirectUri.port);
  }

  late final Alfred _app;
  late final StreamController<String> _s;
  late final Stream<String> stream;

  Future<void> close() async {
    await _app.close();
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
