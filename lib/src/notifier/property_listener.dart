import 'package:flutter/foundation.dart' show ChangeNotifier;

extension PropertyListener on ChangeNotifier {
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
}
