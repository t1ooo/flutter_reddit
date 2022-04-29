import 'dart:async';
import 'dart:io';

import 'package:draw/draw.dart';
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
class CredentialsStorage {
  CredentialsStorage(this.file);
  
  File file;

  Future<String> read() async {
    return file.existsSync() ? await file.readAsString() : '';
  }

  Future<void> write(String data) async{
    await file.writeAsString(data);
  }

   Future<void> delete(String data) async{
    await file.delete();
  }
}

Future<void> authCached() async {
  final file = File('credentials.json');

  final clientId = 'Qg2iboouRpvW_CrGzfxprA';
  final userAgent = 'Flutter Client';
  final redirectUri = Uri.parse('http://127.0.0.1:6565/flutter_app_callback');

  final credentialsJson = await file.exists() ? await file.readAsString() : '';

  final s = AuthServer(redirectUri);

  Reddit reddit;
  if (credentialsJson == '') {
    print('login');
    reddit = await Reddit.createInstalledFlowInstance(
      clientId: clientId,
      userAgent: userAgent,
      redirectUri: redirectUri,
    );

    final authUrl = reddit.auth.url(['*'], 'state');
    print(authUrl);

    final authCode = await s.stream.first;
    await reddit.auth.authorize(authCode);

    await file.writeAsString(reddit.auth.credentials.toJson());
  } else {
    print('cached');
    reddit = Reddit.restoreAuthenticatedInstance(
      credentialsJson,
      clientId: clientId,
      userAgent: userAgent,
      redirectUri: redirectUri,
    );
  }

  print(await reddit.user.me());

  await s.close();
}
