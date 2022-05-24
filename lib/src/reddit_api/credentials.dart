import 'dart:async';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class Credentials {
  Future<String?> read();
  Future<void> write(String data);
  Future<void> delete();
}

/// Insecure. Don't use in production!
class FileCredentials implements Credentials {
  FileCredentials(this.file);

  File file;

  Future<String?> read() async {
    return file.existsSync() ? await file.readAsString() : null;
  }

  Future<void> write(String data) async {
    await file.writeAsString(data);
  }

  Future<void> delete() async {
    await file.delete();
  }
}

class SecureCredentials implements Credentials {
  SecureCredentials() {
    _stor = FlutterSecureStorage(
      aOptions: AndroidOptions(
        resetOnError: true,
        encryptedSharedPreferences: true,
      ),
    );
  }

  late final _stor;
  static const _key = 'reddit_api_credentials';

  Future<String?> read() async {
    return _stor.read(key: _key);
  }

  Future<void> write(String data) async {
    return _stor.write(key: _key, value: data);
  }

  Future<void> delete() async {
    return _stor.delete(key: _key);
  }
}
