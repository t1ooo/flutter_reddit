import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../logging.dart';
import 'ui_exception.dart';

class BaseNotifier with ChangeNotifier {
  late final _log = getLogger(runtimeType.toString());

  Future<T> try_<T>(Future<T> Function() fn, String error) async {
    try {
      return await fn();
    } on Exception catch (e, st) {
      _log.error('', e, st);
      throw UIException(error);
      // ignore: avoid_catching_errors
    } on TypeError catch (e, st) {
      _log.error('', e, st);
      throw UIException(error);
    }
  }

  void addPropertyListener<T>(T Function() select, void Function() listener) {
    var value = select();
    addListener(
      () {
        final newValue = select();
        if (value == newValue) {
          return;
        }
        value = newValue;
        listener();
      },
    );
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}
